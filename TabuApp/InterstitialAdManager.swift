//
//  InterstitialAdManager.swift
//  TabuApp
//

import GoogleMobileAds
import Foundation

@MainActor
final class InterstitialAdManager: NSObject {
    static let shared = InterstitialAdManager()

    private var interstitialAd: InterstitialAd?
    private var lastPresentationDate: Date?
    private var completionAfterDismissal: (() -> Void)?
    private let minimumInterval: TimeInterval = 45

    private override init() {
        super.init()
    }

    func start() {
        MobileAds.shared.start()
        loadAd()
    }

    func loadAd() {
        guard interstitialAd == nil else { return }

        Task {
            do {
                let ad = try await InterstitialAd.load(
                    with: AdsConfiguration.interstitialAdUnitID,
                    request: Request()
                )
                ad.fullScreenContentDelegate = self
                interstitialAd = ad
            } catch {
                #if DEBUG
                print("Interstitial ad failed to load: \(error.localizedDescription)")
                #endif
            }
        }
    }

    /// Shows a prepared ad only at a natural gameplay transition. If no ad is
    /// ready, the caller continues immediately so navigation never gets blocked.
    func showIfAvailable(completion: @escaping () -> Void = {}) {
        guard let interstitialAd,
              !isInCooldown,
              completionAfterDismissal == nil else {
            completion()
            loadAd()
            return
        }

        completionAfterDismissal = completion
        lastPresentationDate = Date()
        self.interstitialAd = nil
        interstitialAd.present(from: nil)
    }

    private var isInCooldown: Bool {
        guard let lastPresentationDate else { return false }
        return Date().timeIntervalSince(lastPresentationDate) < minimumInterval
    }
}

extension InterstitialAdManager: FullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            let completion = completionAfterDismissal
            completionAfterDismissal = nil
            completion?()
            loadAd()
        }
    }

    nonisolated func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        Task { @MainActor in
            #if DEBUG
            print("Interstitial ad failed to present: \(error.localizedDescription)")
            #endif
            let completion = completionAfterDismissal
            completionAfterDismissal = nil
            completion?()
            loadAd()
        }
    }
}
