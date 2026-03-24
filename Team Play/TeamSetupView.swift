//
//  TeamSetupView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//
import SwiftUI

struct TeamSetupView: View {
    @Environment(\.dismiss) private var dismiss
    let category: TabooCategory
    @Binding var navigationPath: NavigationPath
    @State private var team1Name = "Takım 1"
    @State private var team2Name = "Takım 2"
    @State private var roundTime = 60
    @State private var maxRounds = 5
    @State private var showGame = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Circle()
                .fill(Color(hex: "4facfe").opacity(0.15))
                .frame(width: 300)
                .blur(radius: 60)
                .offset(x: -100, y: -150)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("⚙️")
                            .font(.system(size: 48))
                        Text("Oyun Ayarları")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text(category.name)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 8)

                    // Team names
                    DarkSetupSection(title: "🏷 Takım İsimleri") {
                        VStack(spacing: 12) {
                            TeamNameField(icon: "🔴", placeholder: "Takım 1", text: $team1Name)
                            TeamNameField(icon: "🔵", placeholder: "Takım 2", text: $team2Name)
                        }
                    }

                    // Time
                    DarkSetupSection(title: "⏱ Tur Süresi") {
                        HStack(spacing: 10) {
                            ForEach([30, 60, 90, 120], id: \.self) { t in
                                DarkSelectButton(label: "\(t)s", isSelected: roundTime == t,
                                                 gradient: [Color(hex: "4facfe"), Color(hex: "00f2fe")]) {
                                    roundTime = t
                                }
                            }
                        }
                    }

                    // Rounds
                    DarkSetupSection(title: "🔄 Tur Sayısı") {
                        HStack(spacing: 8) {
                            ForEach([3, 5, 7, 9, 11], id: \.self) { r in
                                DarkSelectButton(label: "\(r)", isSelected: maxRounds == r,
                                                 gradient: [Color(hex: "43e97b"), Color(hex: "38f9d7")]) {
                                    maxRounds = r
                                }
                            }
                        }
                    }

                    Button {
                        showGame = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                            Text("Oyuna Başla")
                                .font(.title3.bold())
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color(hex: "4facfe").opacity(0.5), radius: 15, x: 0, y: 8)
                    }
                    .padding(.bottom, 32)
                }
                .padding(.horizontal)
            }

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $showGame) {
            TeamGameView(
                category: category,
                team1Name: team1Name.isEmpty ? "Takım 1" : team1Name,
                team2Name: team2Name.isEmpty ? "Takım 2" : team2Name,
                roundTime: roundTime,
                maxRounds: maxRounds,
                navigationPath: $navigationPath
            )
        }
    }
}

struct TeamNameField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title2)
            TextField(placeholder, text: $text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}
