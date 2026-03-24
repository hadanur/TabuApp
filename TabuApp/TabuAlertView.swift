//
//  TabuAlertView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 24/03/2026.
//

import SwiftUI

struct TabuAlertView: View {
    let title: String
    let message: String
    let confirmText: String
    let cancelText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var appear = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(appear ? 0.6 : 0)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            // Alert card
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [Color(hex: "f5576c"), Color(hex: "f093fb")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: Color(hex: "f5576c").opacity(0.5), radius: 12, x: 0, y: 4)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }

                // Title
                Text(title)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                // Message
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                // Buttons
                VStack(spacing: 10) {
                    Button {
                        onConfirm()
                    } label: {
                        Text(confirmText)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: [Color(hex: "f5576c"), Color(hex: "f093fb")],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        onCancel()
                    } label: {
                        Text(cancelText)
                            .font(.headline.bold())
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(hex: "1a1a2e"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.purple.opacity(0.3), radius: 30, x: 0, y: 10)
            )
            .padding(.horizontal, 40)
            .scaleEffect(appear ? 1 : 0.8)
            .opacity(appear ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}
