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
    @State private var animateSubtitle = false
    @State private var animateButton = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // 1) Deep space background matching app icon
                Color(hex: "170e2b").ignoresSafeArea()
                
                RadialGradient(
                    colors: [Color(hex: "3a1c61").opacity(0.8), .clear],
                    center: .top, startRadius: 10, endRadius: 600
                )
                .ignoresSafeArea()

                // Floating circles decoration
                Circle()
                    .fill(Color(hex: "f472b6").opacity(0.1))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -200)
                    .blur(radius: 60)

                Circle()
                    .fill(Color(hex: "60a5fa").opacity(0.1))
                    .frame(width: 250, height: 250)
                    .offset(x: 120, y: 200)
                    .blur(radius: 60)

                VStack(spacing: 0) {
                    Spacer()

                    // Logo Composite
                    VStack(spacing: 40) {
                        ZStack {
                            // Back card (Pink header)
                            SplashCard(headerColor: Color(hex: "fbcfe8"), isFront: false)
                                .rotationEffect(.degrees(-10))
                                .offset(x: 15, y: -15)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: -5, y: 10)
                            
                            // Front card (Purple header)
                            SplashCard(headerColor: Color(hex: "c4b5fd"), isFront: true)
                                .rotationEffect(.degrees(5))
                                .offset(x: -5, y: 15)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: 5, y: 10)
                            
                            // Bubble
                            SpeechBubble()
                                .scaleEffect(0.65)
                                .offset(x: -60, y: -85)
                                .rotationEffect(.degrees(-8))
                                .shadow(color: .black.opacity(0.4), radius: 15, x: -5, y: 10)
                            
                            // Sparkles
                            SparkleShape()
                                .fill(Color(hex: "f59e0b"))
                                .frame(width: 35, height: 35)
                                .offset(x: 90, y: -90)
                                .rotationEffect(.degrees(animateLogo ? 20 : -20))
                                .shadow(color: Color(hex: "f59e0b").opacity(0.8), radius: 10)
                            
                            SparkleShape()
                                .fill(Color(hex: "fcd34d"))
                                .frame(width: 20, height: 20)
                                .offset(x: 120, y: -50)
                                .rotationEffect(.degrees(animateLogo ? -15 : 25))
                                .shadow(color: Color(hex: "fcd34d").opacity(0.8), radius: 10)
                        }
                        .scaleEffect( animateLogo ? 0.95 : 0.40 ) 
                        .rotationEffect(.degrees(animateLogo ? 0 : -15))
                        .opacity(animateLogo ? 1 : 0)
                        .offset(y: animateLogo ? 0 : 50)

                        VStack(spacing: 12) {
                            Text("TABU".localized())
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.white, Color(hex: "fde68a")],
                                                   startPoint: .top, endPoint: .bottom)
                                )
                                .shadow(color: Color(hex: "f59e0b").opacity(0.4), radius: 8, x: 0, y: 4)
                                .opacity(animateText ? 1 : 0)
                                .offset(y: animateText ? 0 : 30)
                                .scaleEffect(animateText ? 1.0 : 0.8)
                            
                            Text("Yasak kelimeler oyunu".localized())
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .tracking(2)
                                .foregroundColor(Color(hex: "c4b5fd"))
                                .shadow(color: Color(hex: "c4b5fd").opacity(0.5), radius: 5, x: 0, y: 2)
                                .opacity(animateSubtitle ? 1 : 0)
                                .offset(y: animateSubtitle ? 0 : 20)
                        }
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
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
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
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.5)) { animateLogo = true }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.65)) { animateText = true }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.8)) { animateSubtitle = true }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.95)) { animateButton = true }
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
