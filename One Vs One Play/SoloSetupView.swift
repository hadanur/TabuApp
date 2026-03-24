//
//  SoloSetupView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//
import SwiftUI

struct SoloSetupView: View {
    let category: TabooCategory
    @State private var roundTime = 60
    @State private var showGame = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Circle()
                .fill(Color(hex: "f093fb").opacity(0.15))
                .frame(width: 300)
                .blur(radius: 60)
                .offset(x: 100, y: -150)

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("⚙️")
                        .font(.system(size: 48))
                    Text("Solo Setup")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text(category.name)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 8)

                // Time
                DarkSetupSection(title: "⏱ Round Time") {
                    HStack(spacing: 10) {
                        ForEach([30, 60, 90, 120], id: \.self) { t in
                            DarkSelectButton(label: "\(t)s", isSelected: roundTime == t,
                                             gradient: [Color(hex: "f093fb"), Color(hex: "f5576c")]) {
                                roundTime = t
                            }
                        }
                    }
                }

                Spacer()

                Button {
                    showGame = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                        Text("Start Game")
                            .font(.title3.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color(hex: "f093fb").opacity(0.5), radius: 15, x: 0, y: 8)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $showGame) {
            GameView(category: category, roundTime: roundTime)
        }
    }
}

// MARK: - Shared Setup Components
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
