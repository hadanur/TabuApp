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
        "Yasak kelimeler oyunu": ["tr": "Sınırları Zorlayan Eğlence ✨", "en": "Fun Beyond Boundaries ✨"],
        "Hemen Oyna": ["tr": "Hemen Oyna", "en": "Play Now"],
        "Kategori Seç": ["tr": "Meydan Okumanı Seç! 🎯", "en": "Choose Your Challenge! 🎯"],
        "Oynamak için bir konu seç": ["tr": "Hangi desteyle sınırları zorlayacaksın?", "en": "Which deck will you use to break the rules?"],
        "kart": ["tr": "kart", "en": "cards"],
        "Bir Kategori Seç": ["tr": "Bir Deste Seçmelisin!", "en": "You Must Pick a Deck!"],
        "Oyna": ["tr": "Oyna", "en": "Play"],
        
        // Settings / Setup
        "Takımlar": ["tr": "Ekipler", "en": "Squads"],
        "Takım 1": ["tr": "Takım 1", "en": "Team 1"],
        "Takım 2": ["tr": "Takım 2", "en": "Team 2"],
        "Takım İsimleri": ["tr": "Efsanevi Ekipler", "en": "Legendary Squads"],
        "Oyun Ayarları": ["tr": "Kuralları Belirle", "en": "Set the Rules"],
        "Tur Süresi": ["tr": "Zamanla Yarış", "en": "Race Against Time"],
        "Tur Sayısı": ["tr": "Tur Sayısı", "en": "Rounds"],
        "Oyuna Başla": ["tr": "Maceraya Atıl! 🚀", "en": "Jump Into Action! 🚀"],
        
        // Game UI & States
        "Tur": ["tr": "Tur", "en": "Round"],
        "Sıra %@ Takımında!": ["tr": "Sahne %@ Takımının! 🎭", "en": "It's %@ Team's Stage! 🎭"],
        "Telefonu %@ takımına ver": ["tr": "Telefonu %@ takımına devret ve şovu izle!", "en": "Hand the phone to %@ and watch the show!"],
        "Hazırız!": ["tr": "Şovu Başlat! 🎬", "en": "Start the Show! 🎬"],
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
        // Alerts
        "Oyundan Çık?": ["tr": "Oyundan Çık?", "en": "Quit Game?"],
        "Mevcut oyun ilerlemen silinecek. Emin misin?": ["tr": "Mevcut oyun ilerlemen silinecek. Emin misin?", "en": "Current game progress will be lost. Are you sure?"],
        "Evet, Çık": ["tr": "Evet, Çık", "en": "Yes, Quit"],
        "Oyuna Devam Et": ["tr": "Oyuna Devam Et", "en": "Continue Game"],
        
        // Post Game / Stats
        "%@ Kazandı!": ["tr": "%@ Kazandı!", "en": "%@ is Legendary!"],
        "Berabere!": ["tr": "İnanılmaz Bir Beraberlik! 😱", "en": "An Incredible Tie! 😱"],
        "Tekrar Oyna": ["tr": "Tekrar Oyna", "en": "Play Again"],
        "Oyun Duraklatıldı": ["tr": "Oyun Duraklatıldı", "en": "Game Paused"],
        "Tur Bitti!": ["tr": "Zaman Doldu! ⏳", "en": "Time's Up! ⏳"],
        "Sıradaki Takım →": ["tr": "Sıra Rakipte →", "en": "Rival's Turn →"],
        "Sonuçları Gör 🏆": ["tr": "Görkemli Sonuçlar 🏆", "en": "Glorious Results 🏆"]
    ]
}
