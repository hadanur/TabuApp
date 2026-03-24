//
//  TeamGameView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

struct TeamGameView: View {
    let category: TabooCategory
    let team1Name: String
    let team2Name: String
    let roundTime: Int
    let maxRounds: Int
    @Binding var navigationPath: NavigationPath

    @State private var team1Score = 0
    @State private var team2Score = 0
    @State private var currentTeam = 1
    @State private var deck: [TabooCard] = []
    @State private var timeRemaining = 0
    @State private var timer: Timer? = nil
    @State private var phase: GamePhase = .readyToStart
    @State private var roundNumber = 1
    @State private var isGameOver = false
    @State private var correctThisRound = 0
    @State private var tabuThisRound = 0
    @State private var skipCount = 0
    @State private var cardOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1
    @State private var isAnimating = false
    @State private var showHomeAlert = false

    enum GamePhase { case readyToStart, playing, roundOver }

    var currentTeamName: String { currentTeam == 1 ? team1Name : team2Name }
    var teamGradient: [Color] {
        currentTeam == 1
            ? [Color(hex: "f5576c"), Color(hex: "f093fb")]
            : [Color(hex: "4facfe"), Color(hex: "00f2fe")]
    }

    var currentCard: TabooCard? {
        deck.first
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Circle()
                .fill(teamGradient[0].opacity(0.2))
                .frame(width: 300)
                .blur(radius: 60)
                .offset(x: currentTeam == 1 ? -100 : 100, y: -100)
                .animation(.easeInOut(duration: 0.8), value: currentTeam)

            switch phase {
            case .readyToStart: readyView
            case .playing: playingView
            case .roundOver: roundOverView
            }

            if showHomeAlert {
                TabuAlertView(
                    title: "Oyundan Çık?",
                    message: "Mevcut oyun ilerlemen silinecek. Emin misin?",
                    confirmText: "Evet, Çık",
                    cancelText: "Oyuna Devam Et",
                    onConfirm: {
                        timer?.invalidate()
                        navigationPath = NavigationPath()
                    },
                    onCancel: { withAnimation { showHomeAlert = false } }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation { showHomeAlert = true }
                } label: {
                    Image(systemName: "house.fill")
                        .font(.body.bold())
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            deck = category.cards.shuffled()
            timeRemaining = roundTime
        }
        .onDisappear { timer?.invalidate() }
        .navigationDestination(isPresented: $isGameOver) {
            TeamGameOverView(team1Name: team1Name, team2Name: team2Name,
                             team1Score: team1Score, team2Score: team2Score,
                             navigationPath: $navigationPath)
        }
    }

    // MARK: - Ready View
    var readyView: some View {
        VStack(spacing: 0) {
            Spacer()

            scoreBoard.padding(.horizontal)

            Spacer()

            VStack(spacing: 16) {
                Text("Tur \(roundNumber) / \(maxRounds * 2)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))

                Text("Sıra \(currentTeamName) Takımında!")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Telefonu \(currentTeamName) takımına ver")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Button { startRound() } label: {
                HStack(spacing: 10) {
                    Image(systemName: "play.fill")
                    Text("Hazırız!")
                        .font(.title3.bold())
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(colors: teamGradient,
                                   startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: teamGradient[0].opacity(0.5), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 32)
            }

            Spacer().frame(height: 60)
        }
    }

    // MARK: - Playing View
    var playingView: some View {
        VStack(spacing: 16) {
            // Top bar
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "timer")
                    Text("\(timeRemaining)s")
                }
                .font(.title2.bold())
                .foregroundColor(timeRemaining <= 10 ? Color(hex: "f5576c") : .white)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Mini scoreboard
            HStack(spacing: 0) {
                ScorePill(icon: "checkmark", count: correctThisRound, color: .green)
                ScorePill(icon: "forward.fill", count: skipCount, color: .orange)
                ScorePill(icon: "xmark", count: tabuThisRound, color: .red)
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Spacer()

            if let card = currentCard {
                VStack(spacing: 20) {
                    Text(card.word)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: teamGradient,
                                           startPoint: .leading, endPoint: .trailing)
                        )

                    Divider().background(Color.black.opacity(0.1))

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
                .padding(24)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: teamGradient[0].opacity(0.3), radius: 16, x: 0, y: 8)
                .padding(.horizontal)
                .offset(x: cardOffset)
                .opacity(cardOpacity)
            }

            Spacer()

            HStack(spacing: 8) {
                Button {
                    guard !isAnimating, skipCount < 3 else { return }
                    handleAction(.skip)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "forward.fill").font(.title3.bold())
                        Text(skipCount < 3 ? "Pas (\(3 - skipCount))" : "Hakkın Bitti")
                            .font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(skipCount >= 3 ? Color.gray.opacity(0.4) : Color.orange.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(skipCount >= 3 || isAnimating)

                Button {
                    guard !isAnimating else { return }
                    handleAction(.correct)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "checkmark").font(.title3.bold())
                        Text("Doğru").font(.caption.bold())
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
            .padding(.bottom, 32)
        }
    }

    // MARK: - Round Over View
    var roundOverView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("⏰")
                .font(.system(size: 70))

            Text("Tur Bitti!")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.white)

            // Round stats
            HStack(spacing: 0) {
                StatCell(icon: "checkmark.circle.fill", label: "Doğru",
                         value: correctThisRound, color: .green)
                StatCell(icon: "forward.circle.fill", label: "Pas",
                         value: skipCount, color: .orange)
                StatCell(icon: "xmark.circle.fill", label: "Tabu",
                         value: tabuThisRound, color: .red)
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal)

            scoreBoard.padding(.horizontal)

            Spacer()

            let isLastRound = roundNumber >= maxRounds * 2

            Button {
                if isLastRound { isGameOver = true }
                else { nextTeamTurn() }
            } label: {
                Text(isLastRound ? "Sonuçları Gör 🏆" : "Sıradaki Takım →")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: isLastRound
                                ? [Color(hex: "fee140"), Color(hex: "f5576c")]
                                : teamGradient,
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: teamGradient[0].opacity(0.4), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, 32)
            }

            Spacer().frame(height: 60)
        }
    }

    // MARK: - Scoreboard
    var scoreBoard: some View {
        HStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(team1Name)
                    .font(.headline.bold())
                    .foregroundColor(.white.opacity(0.8))
                Text("\(team1Score)")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(
                        currentTeam == 1
                            ? LinearGradient(colors: [Color(hex: "f5576c"), Color(hex: "f093fb")],
                                             startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [.white, .white],
                                             startPoint: .leading, endPoint: .trailing)
                    )
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1, height: 70)

            VStack(spacing: 6) {
                Text(team2Name)
                    .font(.headline.bold())
                    .foregroundColor(.white.opacity(0.8))
                Text("\(team2Score)")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(
                        currentTeam == 2
                            ? LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                                             startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [.white, .white],
                                             startPoint: .leading, endPoint: .trailing)
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Logic
    enum CardAction { case correct, skip, tabu }

    func handleAction(_ action: CardAction) {
        guard !deck.isEmpty else { return }
        isAnimating = true

        let direction: CGFloat = action == .correct ? -1 : 1

        withAnimation(.easeIn(duration: 0.08)) {
            cardOffset = direction * 300
            cardOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            let card = deck.removeFirst()

            switch action {
            case .correct:
                if currentTeam == 1 { team1Score += 1 } else { team2Score += 1 }
                correctThisRound += 1
            case .tabu:
                if currentTeam == 1 { team1Score = max(0, team1Score - 1) }
                else { team2Score = max(0, team2Score - 1) }
                tabuThisRound += 1
            case .skip:
                skipCount += 1
                deck.append(card)
            }

            if deck.isEmpty {
                timer?.invalidate()
                phase = .roundOver
                isAnimating = false
                return
            }

            cardOffset = -direction * 300
            withAnimation(.easeOut(duration: 0.08)) {
                cardOffset = 0
                cardOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                isAnimating = false
            }
        }
    }

    func startRound() {
        deck = category.cards.shuffled()
        timeRemaining = roundTime
        correctThisRound = 0
        tabuThisRound = 0
        skipCount = 0
        phase = .playing
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 { timeRemaining -= 1 }
            else { timer?.invalidate(); phase = .roundOver }
        }
    }

    func nextTeamTurn() {
        currentTeam = currentTeam == 1 ? 2 : 1
        roundNumber += 1
        phase = .readyToStart
        timer?.invalidate()
    }
}
