//
//  GameView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

struct GameView: View {
    let category: TabooCategory
    var roundTime: Int = 60

    @State private var deck: [TabooCard] = []
    @State private var correctCount = 0
    @State private var skipCount = 0
    @State private var tabuCount = 0
    @State private var timeRemaining = 0
    @State private var isGameOver = false
    @State private var timer: Timer? = nil
    @State private var cardOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1
    @State private var isAnimating = false

    var score: Int { correctCount }

    var currentCard: TabooCard? {
        deck.first
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top bar
                HStack {
                    Label("\(timeRemaining)s", systemImage: "timer")
                        .font(.title2.bold())
                        .foregroundColor(timeRemaining <= 10 ? .red : .white)
                    Spacer()
                }
                .padding(.horizontal)

                // Mini scoreboard
                HStack(spacing: 0) {
                    ScorePill(icon: "checkmark", count: correctCount, color: .green)
                    ScorePill(icon: "forward.fill", count: skipCount, color: .orange)
                    ScorePill(icon: "xmark", count: tabuCount, color: .red)
                }
                .background(.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                Spacer()

                // Card
                if let card = currentCard {
                    VStack(spacing: 20) {
                        Text(card.word)
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundColor(.purple)

                        Divider()

                        VStack(spacing: 10) {
                            ForEach(card.forbiddenWords, id: \.self) { word in
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text(word)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 12)
                    .padding(.horizontal)
                    .offset(x: cardOffset)
                    .opacity(cardOpacity)
                }

                Spacer()

                // Buttons
                HStack(spacing: 8) {
                    Button {
                        guard !isAnimating, skipCount < 3 else { return }
                        handleAction(.skip)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "forward.fill").font(.title3.bold())
                            Text(skipCount < 3 ? "Skip (\(3 - skipCount))" : "No Skips")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(skipCount >= 3 ? Color.gray.opacity(0.5) : Color.orange.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(skipCount >= 3 || isAnimating)

                    Button {
                        guard !isAnimating else { return }
                        handleAction(.correct)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "checkmark").font(.title3.bold())
                            Text("Correct").font(.caption.bold())
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isAnimating)

                    Button {
                        guard !isAnimating else { return }
                        handleAction(.tabu)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill").font(.title3.bold())
                            Text("Tabu!").font(.caption.bold())
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isAnimating)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            deck = category.cards.shuffled()
            timeRemaining = roundTime
            startTimer()
        }
        .onDisappear { timer?.invalidate() }
        .navigationDestination(isPresented: $isGameOver) {
            GameOverView(
                score: score,
                correctCount: correctCount,
                skipCount: skipCount,
                tabuCount: tabuCount
            )
        }
    }

    enum CardAction { case correct, skip, tabu }

    func handleAction(_ action: CardAction) {
        guard !deck.isEmpty else { return }
        isAnimating = true

        let direction: CGFloat = action == .correct ? -1 : 1

        withAnimation(.easeIn(duration: 0.20)) {
            cardOffset = direction * 300
            cardOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            // Process the action on the front card
            let card = deck.removeFirst()

            switch action {
            case .correct:
                correctCount += 1
            case .skip:
                skipCount += 1
                deck.append(card) // Passed cards go to the end of the deck
            case .tabu:
                tabuCount += 1
            }

            // Check if deck is empty
            if deck.isEmpty {
                timer?.invalidate()
                isGameOver = true
                isAnimating = false
                return
            }

            // Animate new card in
            cardOffset = -direction * 300
            withAnimation(.easeOut(duration: 0.20)) {
                cardOffset = 0
                cardOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                isAnimating = false
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isGameOver = true
            }
        }
    }
}

struct ScorePill: View {
    let icon: String
    let count: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption.bold())
                .foregroundColor(color)
            Text("\(count)")
                .font(.headline.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
