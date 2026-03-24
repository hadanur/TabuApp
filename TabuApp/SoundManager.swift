import Foundation
import AudioToolbox

class SoundManager {
    static let shared = SoundManager()
    
    // Ses düzeyinin veya titreşimin kapatılıp açılabileceği yapı için ayar opsiyonu eklenebilir.
    
    // Geri sayım (3.. 2.. 1..)
    func playCountdownTick() {
        AudioServicesPlaySystemSound(1052) // Tock
    }
    
    // Geri sayım bitişi (BAŞLA!)
    func playStart() {
        AudioServicesPlaySystemSound(1322) // iOS Success/Payment Chime
    }
    
    // Doğru cevap
    func playCorrect() {
        AudioServicesPlaySystemSound(1057) // Tink
    }
    
    // Tabu (Hatalı/Yasaklı Kelime)
    func playTabu() {
        AudioServicesPlaySystemSound(1321) // iOS Failed/Error Chime
    }
    
    // Pas
    func playSkip() {
        AudioServicesPlaySystemSound(1053) // Low Tock / Swoosh
    }
    
    // Son 10 saniye tiki (Kalp atışı gibi)
    func playTimeWarningWarning() {
        AudioServicesPlaySystemSound(1052) // Tock
    }
    
    // Süre doldu (Tur Bitti)
    func playTimeUp() {
        AudioServicesPlaySystemSound(1054) // Desk Bell / Tink
    }
}
