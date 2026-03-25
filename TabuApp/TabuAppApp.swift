//
//  TabuAppApp.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

@main
struct TabuAppApp: App {
    @State private var showSplash = true
    @ObservedObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .environmentObject(languageManager)
            .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
            .onAppear {
                // Outro completes internally in SplashScreenView, we then unmount it natively
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
