//
//  TeamGameOverView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

struct TeamGameOverView: View {
    let team1Name: String
    let team2Name: String
    let team1Score: Int
    let team2Score: Int
    @Binding var navigationPath: NavigationPath
    @State private var animate = false

    var winner: String? {
        if team1Score > team2Score { return team1Name }
        if team2Score > team1Score { return team2Name }
        return nil
    }

    var winnerGradient: [Color] {
        if team1Score > team2Score { return [Color(hex: "f5576c"), Color(hex: "f093fb")] }
        if team2Score > team1Score { return [Color(hex: "4facfe"), Color(hex: "00f2fe")] }
        return [Color(hex: "43e97b"), Color(hex: "38f9d7")]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(winnerGradient[0].opacity(0.2))
                .frame(width: 350)
                .blur(radius: 70)
                .offset(y: -100)

            VStack(spacing: 32) {
                Spacer()

                // Trophy + winner
                VStack(spacing: 14) {
                    Text(winner != nil ? "🏆" : "🤝")
                        .font(.system(size: 90))
                        .scaleEffect(animate ? 1 : 0.3)
                        .opacity(animate ? 1 : 0)

                    if let winner = winner {
                        Text(String(format: "%@ Kazandı!".localized(), winner))
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: winnerGradient,
                                               startPoint: .top, endPoint: .bottom)
                            )
                            .shadow(color: winnerGradient[0].opacity(0.5), radius: 8, x: 0, y: 4)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Berabere!".localized())
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .gray],
                                               startPoint: .top, endPoint: .bottom)
                            )
                            .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 4)
                            .multilineTextAlignment(.center)
                    }
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)

                // Scores
                HStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(team1Name)
                            .font(.headline.bold())
                            .foregroundColor(.white.opacity(0.7))
                        Text("\(team1Score)")
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundStyle(
                                team1Score >= team2Score
                                    ? LinearGradient(colors: [Color(hex: "f5576c"), Color(hex: "f093fb")],
                                                     startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.4)],
                                                     startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 1, height: 80)

                    VStack(spacing: 8) {
                        Text(team2Name)
                            .font(.headline.bold())
                            .foregroundColor(.white.opacity(0.7))
                        Text("\(team2Score)")
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundStyle(
                                team2Score >= team1Score
                                    ? LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                                                     startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.4)],
                                                     startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 24)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)

                Spacer()

                Button {
                    navigationPath = NavigationPath()
                } label: {
                    Text("Tekrar Oyna".localized())
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: winnerGradient,
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: winnerGradient[0].opacity(0.5), radius: 15, x: 0, y: 8)
                        .padding(.horizontal, 32)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 30)

                Spacer().frame(height: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationPath = NavigationPath()
                } label: {
                    Image(systemName: "house.fill")
                        .font(.body.bold())
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1)) {
                animate = true
            }
        }
    }
}
