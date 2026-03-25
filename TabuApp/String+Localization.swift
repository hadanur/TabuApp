//
//  String+Localization.swift
//  TabuApp
//

import Foundation

extension String {
    func localized() -> String {
        let lang = LanguageManager.shared.currentLanguage
        return AppTranslations.translations[self]?[lang] ?? self
    }
}

struct AppTranslations {
    static let translations: [String: [String: String]] = [
        "TABU": ["tr": "TABUU!", "en": "TABOO!"],
        "Yasak kelimeler oyunu": ["tr": "Yasak kelimeler oyunu", "en": "Forbidden words game"],
        "Hemen Oyna": ["tr": "Hemen Oyna", "en": "Play Now"],
        "Kategori Seç": ["tr": "Kategori Seç", "en": "Select Category"],
        "Oynamak için bir konu seç": ["tr": "Oynamak için bir konu seç", "en": "Choose a topic to play"],
        "kart": ["tr": "kart", "en": "cards"],
        "Bir Kategori Seç": ["tr": "Bir Kategori Seç", "en": "Select a Category"],
        "Oyna": ["tr": "Oyna", "en": "Play"],
        
        // Settings / Setup
        "Takımlar": ["tr": "Takımlar", "en": "Teams"],
        "Takım 1": ["tr": "Takım 1", "en": "Team 1"],
        "Takım 2": ["tr": "Takım 2", "en": "Team 2"],
        "Takım İsimleri": ["tr": "Takım İsimleri", "en": "Team Names"],
        "Oyun Ayarları": ["tr": "Oyun Ayarları", "en": "Game Settings"],
        "Tur Süresi": ["tr": "Tur Süresi", "en": "Round Time"],
        "Tur Sayısı": ["tr": "Tur Sayısı", "en": "Rounds"],
        "Oyuna Başla": ["tr": "Oyuna Başla", "en": "Start Game"],
        
        // Game UI & States
        "Tur": ["tr": "Tur", "en": "Round"],
        "Sıra %@ Takımında!": ["tr": "Sıra %@ Takımında!", "en": "%@ Team's Turn!"],
        "Telefonu %@ takımına ver": ["tr": "Telefonu %@ takımına ver", "en": "Give the phone to the %@ team"],
        "Hazırız!": ["tr": "Hazırız!", "en": "We're Ready!"],
        "BAŞLA!": ["tr": "BAŞLA!", "en": "START!"],
        "sn": ["tr": "sn", "en": "s"],
        "TABU KELİMESİ": ["tr": "TABU KELİMESİ", "en": "TABOO WORD"],
        "YASAKLI KELİMELER": ["tr": "YASAKLI KELİMELER", "en": "FORBIDDEN WORDS"],
        "Pas (%d)": ["tr": "Pas (%d)", "en": "Pass (%d)"],
        "Hakkın Bitti": ["tr": "Hakkın Bitti", "en": "No passes"],
        "Doğru": ["tr": "Doğru", "en": "Correct"],
        "Tabu!": ["tr": "Tabu!", "en": "Taboo!"],
        "Pas": ["tr": "Pas", "en": "Pass"],
        "Tabu": ["tr": "Tabu", "en": "Taboo"],
        "Tur Bitti!": ["tr": "Tur Bitti!", "en": "Round Over!"],
        "Sıradaki Takım →": ["tr": "Sıradaki Takım →", "en": "Next Team →"],
        "Sonuçları Gör 🏆": ["tr": "Sonuçları Gör 🏆", "en": "See Results 🏆"],
        
        // Alerts
        "Oyundan Çık?": ["tr": "Oyundan Çık?", "en": "Quit Game?"],
        "Mevcut oyun ilerlemen silinecek. Emin misin?": ["tr": "Mevcut oyun ilerlemen silinecek. Emin misin?", "en": "Current game progress will be lost. Are you sure?"],
        "Evet, Çık": ["tr": "Evet, Çık", "en": "Yes, Quit"],
        "Oyuna Devam Et": ["tr": "Oyuna Devam Et", "en": "Continue Game"],
        
        // Post Game / Stats
        "%@ Kazandı!": ["tr": "%@ Kazandı!", "en": "%@ Won!"],
        "Berabere!": ["tr": "Berabere!", "en": "It's a Tie!"],
        "Tekrar Oyna": ["tr": "Tekrar Oyna", "en": "Play Again"],
        "Oyun Duraklatıldı": ["tr": "Oyun Duraklatıldı", "en": "Game Paused"]
    ]
}
