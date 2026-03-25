//
//  SplashScreenView.swift
//  TabuApp
//

import SwiftUI

struct SplashScreenView: View {
    @State private var bgAppeared = false
    @State private var cardsPopped = false
    @State private var bubblePopped = false
    @State private var sparklesBeamed = false
    @State private var linesBurst = false

    var body: some View {
        ZStack {
            // 1) Space / Deep Purple Background
            ZStack {
                Color(hex: "170e2b").ignoresSafeArea() // Deep space background
                
                RadialGradient(
                    colors: [Color(hex: "3a1c61").opacity(0.8), .clear],
                    center: .center, startRadius: 10, endRadius: 400
                )
                .ignoresSafeArea()
                .scaleEffect(bgAppeared ? 1 : 0.01)
                
                // Twinkling background stars
                ForEach(0..<20) { i in
                    Circle()
                        .fill(Color(hex: "f472b6").opacity(Double.random(in: 0.2...0.7)))
                        .frame(width: CGFloat.random(in: 2...4))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -300...300)
                        )
                        .opacity(bgAppeared ? 1 : 0)
                        .animation(.easeInOut(duration: Double.random(in: 1.0...2.0)).repeatForever().delay(Double.random(in: 0...1.0)), value: bgAppeared)
                }
            }
            
            // 2) Burst Action Lines behind the cards
            ZStack {
                ForEach(0..<6) { i in
                    let angles: [Double] = [-140, -100, -20, 20, 110, 150]
                    Capsule()
                        .fill(Color(hex: "fde68a"))
                        .frame(width: 60, height: 6)
                        .offset(x: linesBurst ? 160 : 60)
                        .rotationEffect(.degrees(angles[i]))
                        .opacity(linesBurst ? 1 : 0)
                }
            }
            
            // 3) Overlapping Cards
            ZStack {
                // Back card (Pink header)
                SplashCard(headerColor: Color(hex: "fbcfe8"), isFront: false)
                    .rotationEffect(.degrees(-12))
                    .offset(x: 20, y: -20)
                    .scaleEffect(cardsPopped ? 1 : 0.01)
                
                // Front card (Purple header)
                SplashCard(headerColor: Color(hex: "c4b5fd"), isFront: true)
                    .rotationEffect(.degrees(6))
                    .offset(x: -10, y: 20)
                    .scaleEffect(cardsPopped ? 1 : 0.01)
            }
            .offset(x: 30, y: 40) // Shift cards slightly right to balance the bubble
            
            // 4) Speech Bubble
            SpeechBubble()
                .offset(x: -90, y: -100)
                .scaleEffect(bubblePopped ? 1 : 0.01)
                .rotationEffect(.degrees(bubblePopped ? 0 : -20))
            
            // 5) Golden Sparkles
            ZStack {
                // Large sparkle right
                SparkleShape()
                    .fill(Color(hex: "f59e0b"))
                    .frame(width: 50, height: 50)
                    .offset(x: 120, y: -110)
                    .rotationEffect(.degrees(sparklesBeamed ? 15 : -45))
                    .scaleEffect(sparklesBeamed ? 1 : 0.01)
                
                // Small sparkle right
                SparkleShape()
                    .fill(Color(hex: "fcd34d"))
                    .frame(width: 30, height: 30)
                    .offset(x: 160, y: -70)
                    .rotationEffect(.degrees(sparklesBeamed ? -10 : 30))
                    .scaleEffect(sparklesBeamed ? 1 : 0.01)
            }
            
        }
        .onAppear {
            // INTRO SEQUENCE
            withAnimation(.easeOut(duration: 1.0)) { bgAppeared = true }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) { cardsPopped = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { linesBurst = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) { bubblePopped = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) { sparklesBeamed = true }
            }
            
            // OUTRO SEQUENCE
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeIn(duration: 0.25)) { sparklesBeamed = false }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.95) {
                withAnimation(.easeIn(duration: 0.25)) { bubblePopped = false }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation(.easeIn(duration: 0.3)) { linesBurst = false }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
                withAnimation(.easeIn(duration: 0.35)) { cardsPopped = false }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.45) {
                withAnimation(.easeInOut(duration: 0.5)) { bgAppeared = false }
            }
        }
    }
}

// MARK: - Subcomponents

struct SplashCard: View {
    var headerColor: Color
    var isFront: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
            
            VStack(spacing: 0) {
                headerColor
                    .frame(height: 30)
                
                VStack(spacing: 16) {
                    if isFront {
                        ForEach(0..<4, id: \.self) { _ in
                            Capsule()
                                .fill(Color(hex: "fde68a")) // Yellowish line
                                .frame(height: 5)
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                
                Spacer()
            }
            
            // Hand-drawn thick black borders
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(hex: "1a1a1a"), lineWidth: 7)
            
            // Header separator line
            Rectangle()
                .fill(Color(hex: "1a1a1a"))
                .frame(height: 7)
                .offset(y: 26)
        }
        .frame(width: 150, height: 230)
    }
}

struct SpeechBubble: View {
    var body: some View {
        ZStack {
            // Tail
            Path { path in
                path.move(to: CGPoint(x: 50, y: 70))
                path.addLine(to: CGPoint(x: 75, y: 130)) // Pointing down to cards
                path.addLine(to: CGPoint(x: 90, y: 70))
            }
            .fill(Color(hex: "fefce8")) // Cream white
            
            // Main circle
            Circle()
                .fill(Color(hex: "fefce8"))
                .frame(width: 130, height: 130)
            
            // Blue inner circle
            ZStack {
                Circle()
                    .fill(Color(hex: "2563eb")) // bright blue
                
                Text("?")
                    .font(.system(size: 55, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
            }
            .frame(width: 75, height: 75)
            .offset(y: -5)
        }
        .frame(width: 130, height: 150)
    }
}

struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        
        path.move(to: CGPoint(x: cx, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: cy), control: CGPoint(x: cx, y: cy))
        path.addQuadCurve(to: CGPoint(x: cx, y: rect.maxY), control: CGPoint(x: cx, y: cy))
        path.addQuadCurve(to: CGPoint(x: 0, y: cy), control: CGPoint(x: cx, y: cy))
        path.addQuadCurve(to: CGPoint(x: cx, y: 0), control: CGPoint(x: cx, y: cy))
        
        return path
    }
}
