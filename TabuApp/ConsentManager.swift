//
//  ConsentManager.swift
//  TabuApp
//

import UserMessagingPlatform

@MainActor
final class ConsentManager {
    static let shared = ConsentManager()

    private var hasStartedAds = false

    private init() {}

    /// Updates consent on every launch and presents Google's form when required.
    /// Configure the message in AdMob's Privacy & messaging section before release.
    func gatherConsentAndStartAds() {
        let parameters = RequestParameters()

        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [weak self] error in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if ConsentInformation.shared.canRequestAds {
                    self.startAdsIfNeeded()
                }

                guard error == nil else { return }

                ConsentForm.loadAndPresentIfRequired(from: nil) { _ in
                    Task { @MainActor [weak self] in
                        guard let self, ConsentInformation.shared.canRequestAds else { return }
                        self.startAdsIfNeeded()
                    }
                }
            }
        }
    }

    func presentPrivacyOptions() {
        ConsentForm.presentPrivacyOptionsForm(from: nil, completionHandler: nil)
    }

    private func startAdsIfNeeded() {
        guard !hasStartedAds else { return }
        hasStartedAds = true
        InterstitialAdManager.shared.start()
    }
}
