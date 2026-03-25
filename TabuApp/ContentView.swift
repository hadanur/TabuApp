//
//  ContentView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showCategorySelection = false
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var animateButton = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Background
                LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                // Floating circles decoration
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -200)
                    .blur(radius: 40)

                Circle()
                    .fill(Color.indigo.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .offset(x: 120, y: 200)
                    .blur(radius: 50)

                VStack(spacing: 0) {
                    Spacer()

                    // Logo
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.purple, .indigo],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 120)
                                .shadow(color: .purple.opacity(0.5), radius: 20, x: 0, y: 10)
                                .scaleEffect(animateLogo ? 1.0 : 0.8)

                            Text("🤫")
                                .font(.system(size: 60))
                                .scaleEffect(animateLogo ? 1.0 : 0.8)
                        }

                        Text("TABU".localized())
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, Color(hex: "a78bfa")],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .opacity(animateText ? 1 : 0)
                            .offset(y: animateText ? 0 : 20)

                        Text("Yasak kelimeler oyunu".localized())
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                            .opacity(animateText ? 1 : 0)
                            .offset(y: animateText ? 0 : 10)
                    }

                    Spacer()

                    // Play button
                    Button {
                        navigationPath.append("categorySelection")
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.title3)
                            Text("Hemen Oyna".localized())
                                .font(.title3.bold())
                        }
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
                    .opacity(animateButton ? 1 : 0)
                    .offset(y: animateButton ? 0 : 30)
                    .scaleEffect(animateButton ? 1.0 : 0.95)

                    Spacer().frame(height: 60)
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        languageManager.toggleLanguage()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                        Text(languageManager.currentLanguage.uppercased())
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(colors: [.purple, .indigo], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .padding()
                .padding(.top, 40)
                .opacity(animateButton ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.6)) { animateLogo = true }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.75)) { animateText = true }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.9)) { animateButton = true }
            }
            .navigationDestination(for: String.self) { value in
                if value == "categorySelection" {
                    CategorySelectionView(navigationPath: $navigationPath)
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
