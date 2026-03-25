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
    @State private var countdownNumber = 3
    @State private var countdownScale: CGFloat = 0.5
    @State private var roundNumber = 1
    @State private var isGameOver = false
    @State private var correctThisRound = 0
    @State private var tabuThisRound = 0
    @State private var skipCount = 0
    @State private var cardOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1
    @State private var isAnimating = false
    @State private var showHomeAlert = false
    @State private var isPaused = false

    enum GamePhase { case readyToStart, countdown, playing, roundOver }

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

            Group {
                switch phase {
                case .readyToStart:
                    readyView.transition(.opacity.combined(with: .scale(scale: 0.95)))
                case .countdown:
                    countdownView.transition(.opacity)
                case .playing:
                    playingView.transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                case .roundOver:
                    roundOverView.transition(.asymmetric(insertion: .scale(scale: 0.8).combined(with: .opacity), removal: .move(edge: .bottom)))
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: phase)

            if showHomeAlert {
                TabuAlertView(
                    title: "Oyundan Çık?".localized(),
                    message: "Mevcut oyun ilerlemen silinecek. Emin misin?".localized(),
                    confirmText: "Evet, Çık".localized(),
                    cancelText: "Oyuna Devam Et".localized(),
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
            ToolbarItem(placement: .navigationBarTrailing) {
                if phase == .playing {
                    Button {
                        withAnimation { isPaused.toggle() }
                    } label: {
                        Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(colors: teamGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: teamGradient[0].opacity(0.4), radius: 4, x: 0, y: 2)
                    }
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
                Text("\("Tur".localized()) \(roundNumber) / \(maxRounds * 2)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())

                Text(String(format: "Sıra %@ Takımında!".localized(), currentTeamName))
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: teamGradient,
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(color: teamGradient[0].opacity(0.5), radius: 8, x: 0, y: 4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(String(format: "Telefonu %@ takımına ver".localized(), currentTeamName))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button { startRound() } label: {
                HStack(spacing: 10) {
                    Image(systemName: "play.fill")
                    Text("Hazırız!".localized())
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

    // MARK: - Countdown View
    var countdownView: some View {
        ZStack {
            Text(countdownNumber > 0 ? "\(countdownNumber)" : "BAŞLA!".localized())
                .font(.system(size: countdownNumber > 0 ? 150 : 80, weight: .black, design: .rounded))
                .foregroundColor(countdownNumber > 0 ? .white : Color(hex: "43e97b"))
                .scaleEffect(countdownScale)
                .opacity(countdownScale > 1.2 ? 0 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            runCountdown()
        }
    }

    func runCountdown() {
        countdownNumber = 3
        animateNumber()
    }
    
    func animateNumber() {
        guard phase == .countdown else { return }
        
        countdownScale = 0.3
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            countdownScale = 1.0
        }
        
        if countdownNumber > 0 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            SoundManager.shared.playCountdownTick()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            SoundManager.shared.playStart()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard phase == .countdown else { return }
            withAnimation(.easeIn(duration: 0.2)) {
                countdownScale = 1.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            guard phase == .countdown else { return }
            if countdownNumber > 0 {
                countdownNumber -= 1
                animateNumber()
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    phase = .playing
                    startTimer()
                }
            }
        }
    }

    // MARK: - Playing View
    var playingView: some View {
        VStack(spacing: 16) {
            // Modern Centered Timer
            HStack {
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: timeRemaining <= 10 ? "alarm.fill" : "timer")
                        .font(.system(size: 22, weight: .bold))
                    
                    Text("\(timeRemaining)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .monospacedDigit()
                    
                    Text("sn".localized())
                        .font(.headline.bold())
                        .foregroundColor(.white.opacity(0.8))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(
                            timeRemaining <= 10
                            ? LinearGradient(colors: [Color(hex: "ff0844"), Color(hex: "ffb199")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(
                            timeRemaining <= 10 ? Color(hex: "ffb199").opacity(0.6) : Color.white.opacity(0.3),
                            lineWidth: 1
                        )
                )
                .shadow(color: timeRemaining <= 10 ? Color(hex: "ff0844").opacity(0.6) : Color.black.opacity(0.2), radius: timeRemaining <= 10 ? 15 : 10, x: 0, y: 5)
                .scaleEffect(timeRemaining <= 10 ? 1.05 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: timeRemaining <= 10)
                
                Spacer()
            }
            .padding(.top, 10)

            // Mini scoreboard
            HStack(spacing: 12) {
                ScorePill(icon: "forward.fill", count: skipCount, color: .orange)
                ScorePill(icon: "checkmark", count: correctThisRound, color: .green)
                ScorePill(icon: "exclamationmark.triangle.fill", count: tabuThisRound, color: .red)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            Spacer()

            if let card = currentCard {
                VStack(spacing: 0) {
                    // Header section
                        VStack(spacing: 8) {
                            Text("TABU KELİMESİ".localized())
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.85))
                                .tracking(2)
                            
                            Text(card.word)
                                .font(.system(size: 38, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal)
                        .background(
                            LinearGradient(colors: teamGradient,
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        
                        // Forbidden words section
                        VStack(spacing: 12) {
                            Text("YASAKLI KELİMELER".localized())
                                .font(.caption.bold())
                                .foregroundColor(.gray.opacity(0.8))
                                .tracking(2)
                                .padding(.top, 20)
                                .padding(.bottom, 4)
                            
                            ForEach(card.forbiddenWords, id: \.self) { word in
                                HStack(spacing: 16) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(.white)
                                        .frame(width: 26, height: 26)
                                        .background(
                                            LinearGradient(colors: [Color(hex: "ff416c"), Color(hex: "ff4b2b")],
                                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .clipShape(Circle())
                                        .shadow(color: Color(hex: "ff4b2b").opacity(0.4), radius: 4, x: 0, y: 2)
                                    
                                    Text(word)
                                        .font(.system(size: 19, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.8))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.06))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                }
                .blur(radius: isPaused ? 18 : 0)
                .opacity(isPaused ? 0.4 : 1)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .drawingGroup() // Hardware acceleration flatten to kill shadow lag
                .shadow(color: teamGradient[0].opacity(0.4), radius: 25, x: 0, y: 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 24)
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
                        Text(skipCount < 3 ? String(format: "Pas (%d)".localized(), 3 - skipCount) : "Hakkın Bitti".localized())
                            .font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(skipCount >= 3 ? Color.gray.opacity(0.4) : Color.orange.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(skipCount >= 3 || isAnimating || isPaused)
                .opacity(isPaused ? 0.5 : 1)

                Button {
                    guard !isAnimating else { return }
                    handleAction(.correct)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "checkmark").font(.title3.bold())
                        Text("Doğru".localized()).font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.green.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isAnimating || isPaused)
                .opacity(isPaused ? 0.5 : 1)

                Button {
                    guard !isAnimating else { return }
                    handleAction(.tabu)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill").font(.title3.bold())
                        Text("Tabu!".localized()).font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isAnimating || isPaused)
                .opacity(isPaused ? 0.5 : 1)
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

            Text("Tur Bitti!".localized())
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.white, Color(hex: "fde68a")],
                                   startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: Color(hex: "f59e0b").opacity(0.3), radius: 6, x: 0, y: 3)

            HStack(spacing: 8) {
                StatCell(icon: "checkmark.circle.fill", label: "Doğru".localized(),
                         value: correctThisRound, color: .green)
                StatCell(icon: "forward.circle.fill", label: "Pas".localized(),
                         value: skipCount, color: .orange)
                StatCell(icon: "xmark.circle.fill", label: "Tabu".localized(),
                         value: tabuThisRound, color: .red)

            }
            .padding(.horizontal)

            scoreBoard.padding(.horizontal)

            Spacer()

            let isLastRound = roundNumber >= maxRounds * 2

            Button {
                if isLastRound { isGameOver = true }
                else { nextTeamTurn() }
            } label: {
                Text(isLastRound ? "Sonuçları Gör 🏆".localized() : "Sıradaki Takım →".localized())
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

        withAnimation(.easeIn(duration: 0.15)) {
            cardOffset = direction * 300
            cardOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let card = deck.removeFirst()

            switch action {
            case .correct:
                if currentTeam == 1 { team1Score += 1 } else { team2Score += 1 }
                correctThisRound += 1
                SoundManager.shared.playCorrect()
            case .tabu:
                if currentTeam == 1 { team1Score = max(0, team1Score - 1) }
                else { team2Score = max(0, team2Score - 1) }
                tabuThisRound += 1
                SoundManager.shared.playTabu()
            case .skip:
                skipCount += 1
                deck.append(card)
                SoundManager.shared.playSkip()
            }

            if deck.isEmpty {
                timer?.invalidate()
                withAnimation { phase = .roundOver }
                isAnimating = false
                return
            }

            cardOffset = -direction * 300
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                cardOffset = 0
                cardOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
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
        isPaused = false
        withAnimation { phase = .countdown }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard !isPaused else { return }
            if timeRemaining > 0 { 
                timeRemaining -= 1 
                if timeRemaining <= 10 && timeRemaining > 0 {
                    SoundManager.shared.playTimeWarningWarning()
                }
            }
            else { 
                timer?.invalidate()
                SoundManager.shared.playTimeUp()
                withAnimation { phase = .roundOver }
            }
        }
    }

    func nextTeamTurn() {
        currentTeam = currentTeam == 1 ? 2 : 1
        roundNumber += 1
        timer?.invalidate()
        withAnimation { phase = .readyToStart }
    }
}

struct DarkSetupSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            content
        }
        .padding(20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct DarkSelectButton: View {
    let label: String
    let isSelected: Bool
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(colors: gradient,
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        } else {
                            LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: isSelected ? gradient[0].opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
        }
    }
}
