//
//  GameOverView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//
import SwiftUI

struct GameOverView: View {
    let score: Int
    var correctCount: Int = 0
    var skipCount: Int = 0
    var tabuCount: Int = 0
    @Environment(\.dismiss) var dismiss
    @State private var animate = false

    var emoji: String {
        if score >= 15 { return "🏆" }
        if score >= 10 { return "🎉" }
        if score >= 5 { return "😅" }
        return "💀"
    }

    var message: String {
        if score >= 15 { return "Incredible!" }
        if score >= 10 { return "Nice work!" }
        if score >= 5 { return "Not bad!" }
        return "Try again!"
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            // Glow
            Circle()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 300)
                .blur(radius: 60)
                .offset(y: -100)

            VStack(spacing: 32) {
                Spacer()

                // Emoji + message
                VStack(spacing: 12) {
                    Text(emoji)
                        .font(.system(size: 90))
                        .scaleEffect(animate ? 1 : 0.5)
                        .opacity(animate ? 1 : 0)

                    Text(message)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 20)
                }

                // Score
                VStack(spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 90, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.yellow, .orange],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .scaleEffect(animate ? 1 : 0.3)
                        .opacity(animate ? 1 : 0)

                    Text("points")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.4))
                }

                // Stats
                HStack(spacing: 0) {
                    StatCell(icon: "checkmark.circle.fill", label: "Correct",
                             value: correctCount, color: .green)
                    StatCell(icon: "forward.circle.fill", label: "Skipped",
                             value: skipCount, color: .orange)
                    StatCell(icon: "xmark.circle.fill", label: "Tabu",
                             value: tabuCount, color: .red)
                }
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
                .opacity(animate ? 1 : 0)

                Spacer()

                Button {
                    dismiss(); dismiss(); dismiss()
                } label: {
                    Text("Play Again")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [.purple, .indigo],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .purple.opacity(0.5), radius: 15, x: 0, y: 8)
                        .padding(.horizontal, 32)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 30)

                Spacer().frame(height: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1)) {
                animate = true
            }
        }
    }
}

struct StatCell: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text("\(value)")
                .font(.title.bold())
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
    }
}
