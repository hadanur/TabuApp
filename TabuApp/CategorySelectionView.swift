//
//  CategorySelectionView.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath
    @State private var selectedCategory: TabooCategory? = nil
    @State private var showGameSetup = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var orderedCategories: [TabooCategory] {
        var cats = WordDatabase.categories
        if let index = cats.firstIndex(where: { $0.name == "Karışık" }) {
            let mixedCategory = cats.remove(at: index)
            cats.insert(mixedCategory, at: 0)
        }
        return cats
    }

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                // Scrollable content
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Kategori Seç".localized())
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Oynamak için bir konu seç".localized())
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(orderedCategories) { category in
                                CategoryCard(category: category,
                                             isSelected: selectedCategory?.id == category.id)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedCategory = category
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 160)
                    }
                }

                // Floating bottom button with fade
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [Color(hex: "1a1a2e").opacity(0), Color(hex: "1a1a2e")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 48)

                    VStack {
                        Button {
                            showGameSetup = true
                        } label: {
                            HStack(spacing: 10) {
                                if let cat = selectedCategory {
                                    Text(cat.emoji)
                                        .font(.title3)
                                    Text("\(cat.name) \("Oyna".localized())")
                                        .font(.headline.bold())
                                } else {
                                    Text("Bir Kategori Seç".localized())
                                        .font(.headline.bold())
                                }
                            }
                            .foregroundColor(selectedCategory == nil ? .white.opacity(0.4) : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                Group {
                                    if selectedCategory != nil {
                                        LinearGradient(colors: [.purple, .indigo],
                                                       startPoint: .leading, endPoint: .trailing)
                                    } else {
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)],
                                            startPoint: .leading, endPoint: .trailing)
                                    }
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: selectedCategory != nil ? .purple.opacity(0.4) : .clear,
                                    radius: 15, x: 0, y: 8)
                            .padding(.horizontal, 24)
                        }
                        .disabled(selectedCategory == nil)
                        .animation(.spring(response: 0.3), value: selectedCategory?.id)
                    }
                    .padding(.bottom, 36)
                    .background(Color(hex: "1a1a2e"))
                }
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
        .navigationDestination(isPresented: $showGameSetup) {
            if let category = selectedCategory {
                TeamSetupView(category: category, navigationPath: $navigationPath)
            }
        }
    }
}

struct CategoryCard: View {
    let category: TabooCategory
    let isSelected: Bool

    private let cardColors: [[Color]] = [
        [Color(hex: "667eea"), Color(hex: "764ba2")],
        [Color(hex: "f093fb"), Color(hex: "f5576c")],
        [Color(hex: "4facfe"), Color(hex: "00f2fe")],
        [Color(hex: "43e97b"), Color(hex: "38f9d7")],
        [Color(hex: "fa709a"), Color(hex: "fee140")],
        [Color(hex: "a18cd1"), Color(hex: "fbc2eb")],
        [Color(hex: "ffecd2"), Color(hex: "fcb69f")],
        [Color(hex: "ff9a9e"), Color(hex: "fecfef")],
        [Color(hex: "a1c4fd"), Color(hex: "c2e9fb")],
        [Color(hex: "fd7043"), Color(hex: "ff8a65")],
    ]

    var gradientColors: [Color] {
        if category.name == "Karışık" {
            // A unique, vibrant golden/orange gradient for the mixed category
            return [Color(hex: "FFB75E"), Color(hex: "ED8F03")]
        }
        let index = abs(category.name.hashValue) % cardColors.count
        return cardColors[index]
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(category.emoji)
                .font(.system(size: 40))
                .shadow(radius: 4)

            Text(category.name)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("\(category.cards.count) \("kart".localized())")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            LinearGradient(colors: gradientColors,
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
        )
        .shadow(color: isSelected ? gradientColors[0].opacity(0.6) : .black.opacity(0.2),
                radius: isSelected ? 12 : 6, x: 0, y: 4)
        .scaleEffect(isSelected ? 1.04 : 1.0)
    }
}
