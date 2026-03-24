//
//  GameModeSelectionView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

struct GameModeSelectionView: View {
    let category: TabooCategory
    @State private var showSolo = false
    @State private var showTeam = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                VStack(spacing: 10) {
                    Text(category.emoji)
                        .font(.system(size: 64))
                        .shadow(radius: 8)
                    Text(category.name)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("How do you want to play?")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                VStack(spacing: 16) {
                    ModeCard(
                        icon: "person.fill",
                        title: "Solo",
                        description: "Play alone, beat your score",
                        gradient: [Color(hex: "f093fb"), Color(hex: "f5576c")]
                    ) { showSolo = true }

                    ModeCard(
                        icon: "person.2.fill",
                        title: "Teams",
                        description: "2 teams take turns",
                        gradient: [Color(hex: "4facfe"), Color(hex: "00f2fe")]
                    ) { showTeam = true }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct ModeCard: View {
    let icon: String
    let title: String
    let description: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: gradient,
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                        .shadow(color: gradient[0].opacity(0.5), radius: 8, x: 0, y: 4)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.3))
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
}
