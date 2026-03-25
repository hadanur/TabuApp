//
//  LanguageManager.swift
//  TabuApp
//

import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String = "en"
    
    init() {
        let storedLang = UserDefaults.standard.string(forKey: "appLanguage") ?? ""
        if !storedLang.isEmpty {
            self.currentLanguage = storedLang
        } else {
            let defaultLang = Locale.current.languageCode ?? "en"
            self.currentLanguage = (defaultLang == "tr" ? "tr" : "en")
        }
    }
    
    func toggleLanguage() {
        let newLang = (currentLanguage == "tr") ? "en" : "tr"
        currentLanguage = newLang
        UserDefaults.standard.set(newLang, forKey: "appLanguage")
    }
}
