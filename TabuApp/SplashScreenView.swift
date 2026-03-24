//
//  SplashScreenView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 18/03/2026.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var bgAppeared = false
    @State private var ringDrawn = false
    @State private var slashDrawn = false
    @State private var orbPopped = false
    @State private var burst = false
    @State private var shineRotation: Double = 0

    var body: some View {
        ZStack {

            // ── Background ──────────────────────────────────────────
            ZStack {
                Color(hex: "050510").ignoresSafeArea()

                // Deep color clouds
                RadialGradient(
                    colors: [Color(hex: "3b0764").opacity(0.9), .clear],
                    center: .center, startRadius: 0, endRadius: 400
                )
                .ignoresSafeArea()
                .scaleEffect(bgAppeared ? 1 : 0.01)
                .animation(.easeOut(duration: 1.2), value: bgAppeared)

                Circle()
                    .fill(Color(hex: "be185d").opacity(0.25))
                    .frame(width: 500)
                    .blur(radius: 100)
                    .offset(x: -100, y: -200)
                    .scaleEffect(bgAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 1.4).delay(0.2), value: bgAppeared)

                Circle()
                    .fill(Color(hex: "1d4ed8").opacity(0.2))
                    .frame(width: 400)
                    .blur(radius: 90)
                    .offset(x: 120, y: 200)
                    .scaleEffect(bgAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 1.4).delay(0.3), value: bgAppeared)
            }

            // ── Grid lines (subtle) ──────────────────────────────────
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let cols = 8
                let rows = 14
                Path { path in
                    for i in 0...cols {
                        let x = w / CGFloat(cols) * CGFloat(i)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: h))
                    }
                    for i in 0...rows {
                        let y = h / CGFloat(rows) * CGFloat(i)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: w, y: y))
                    }
                }
                .stroke(Color.white.opacity(bgAppeared ? 0.04 : 0), lineWidth: 0.5)
                .animation(.easeIn(duration: 1.0).delay(0.5), value: bgAppeared)
            }
            .ignoresSafeArea()

            // ── Burst rays ───────────────────────────────────────────
            ZStack {
                ForEach(0..<12) { i in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "e879f9").opacity(0.6), .clear],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: burst ? 300 : 0, height: 2)
                        .offset(x: burst ? 150 : 0)
                        .rotationEffect(.degrees(Double(i) * 30))
                        .animation(
                            .easeOut(duration: 0.7).delay(Double(i) * 0.02),
                            value: burst
                        )
                }
            }
            .opacity(burst ? 1 : 0)

            // ── Prohibition ring (self-drawing) ──────────────────────
            ZStack {
                // Glow behind ring
                Circle()
                    .fill(Color(hex: "dc2626").opacity(0.12))
                    .frame(width: 280, height: 280)
                    .blur(radius: 20)
                    .scaleEffect(ringDrawn ? 1 : 0.5)
                    .opacity(ringDrawn ? 1 : 0)
                    .animation(.easeOut(duration: 0.8), value: ringDrawn)

                // Ring draw animation
                Circle()
                    .trim(from: 0, to: ringDrawn ? 1 : 0)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color(hex: "ff4444"),
                                Color(hex: "ff0080"),
                                Color(hex: "ff4444")
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 240, height: 240)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.9).delay(0.3), value: ringDrawn)
                    .shadow(color: Color(hex: "ff4444").opacity(0.8), radius: 12)

                // Slash line draw
                SlashLine(progress: slashDrawn ? 1 : 0)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "ff4444"), Color(hex: "ff0080")],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 240, height: 240)
                    .shadow(color: Color(hex: "ff4444").opacity(0.8), radius: 12)
                    .animation(.easeInOut(duration: 0.55).delay(1.15), value: slashDrawn)
            }

            // ── Center orb pop ───────────────────────────────────────
            ZStack {
                // Pulse rings
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(Color(hex: "a855f7").opacity(orbPopped ? 0 : 0.6), lineWidth: 2)
                        .frame(width: 90, height: 90)
                        .scaleEffect(orbPopped ? CGFloat(2.5 + Double(i) * 0.8) : 1)
                        .opacity(orbPopped ? 0 : 0)
                        .animation(
                            .easeOut(duration: 0.9).delay(1.7 + Double(i) * 0.15),
                            value: orbPopped
                        )
                }

                // Main orb
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: "a855f7").opacity(0.6), .clear],
                                center: .center, startRadius: 0, endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .blur(radius: 16)

                    // Body
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "c026d3"), Color(hex: "7c3aed"), Color(hex: "1d4ed8")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color(hex: "a855f7").opacity(1), radius: 24)

                    // Rotating shine
                    Ellipse()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: 28, height: 48)
                        .offset(x: -10, y: -8)
                        .rotationEffect(.degrees(shineRotation))
                        .clipShape(Circle().size(width: 80, height: 80).offset(x: -40, y: -40))

                    // 🤫
                    Text("🤫")
                        .font(.system(size: 34))
                        .scaleEffect(orbPopped ? 1 : 0.3)
                        .animation(.spring(response: 0.5, dampingFraction: 0.55).delay(1.75), value: orbPopped)
                }
                .scaleEffect(orbPopped ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.45).delay(1.65), value: orbPopped)
            }

            // ── Floating sparkles ────────────────────────────────────
            ForEach(0..<16) { i in
                let angle = Double(i) / 16.0 * 360.0
                let dist = CGFloat.random(in: 140...240)
                let sz = CGFloat.random(in: 2.5...5.5)
                let colors: [Color] = [
                    Color(hex: "f0abfc"), Color(hex: "818cf8"),
                    Color(hex: "f472b6"), .white, Color(hex: "60a5fa")
                ]
                Circle()
                    .fill(colors[i % colors.count])
                    .frame(width: sz, height: sz)
                    .shadow(color: colors[i % colors.count].opacity(0.9), radius: sz * 2)
                    .offset(
                        x: burst ? dist * cos(angle * .pi / 180) : 0,
                        y: burst ? dist * sin(angle * .pi / 180) : 0
                    )
                    .opacity(burst ? Double.random(in: 0.5...1.0) : 0)
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.55)
                        .delay(1.7 + Double(i) * 0.025),
                        value: burst
                    )
            }
        }
        .onAppear {
            bgAppeared = true
            withAnimation { ringDrawn = true }
            withAnimation { slashDrawn = true }
            withAnimation {
                orbPopped = true
                burst = true
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false).delay(1.8)) {
                shineRotation = 360
            }
        }
    }
}

// Diagonal slash path inside circle
struct SlashLine: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = rect.width / 2
        let angle: CGFloat = 40 * .pi / 180
        let x0 = rect.midX + r * cos(.pi - angle)
        let y0 = rect.midY - r * sin(.pi - angle)
        let x1 = rect.midX + r * cos(-angle)
        let y1 = rect.midY - r * sin(-angle)
        let currentX = x0 + (x1 - x0) * progress
        let currentY = y0 + (y1 - y0) * progress
        path.move(to: CGPoint(x: x0, y: y0))
        path.addLine(to: CGPoint(x: currentX, y: currentY))
        return path
    }
}
