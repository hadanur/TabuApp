//
//  Model.swift
//  TabuApp
//
//  Created by Hakan Adanur on 08/03/2026.
//

import Foundation

struct TabooCard: Identifiable {
    let id = UUID()
    let word: String
    let forbiddenWords: [String]
    let category: String
}

struct TabooCategory: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let cards: [TabooCard]
}
