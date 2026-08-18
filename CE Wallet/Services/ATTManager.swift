//
//  ATTManager.swift
//  CEWallet
//

import AppTrackingTransparency

/// Requests App Tracking Transparency authorization, which AdMob needs to
/// serve personalized ads. Requested at most once, the first time the app
/// becomes active after install.
enum ATTManager {
    private static let didRequestKey = "didRequestTrackingAuthorization"

    static func requestTrackingAuthorizationIfNeeded() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        guard !UserDefaults.standard.bool(forKey: didRequestKey) else { return }
        UserDefaults.standard.set(true, forKey: didRequestKey)

        ATTrackingManager.requestTrackingAuthorization { _ in }
    }

    /// Whether AdMob should be told to request non-personalized ads only.
    static var shouldRequestNonPersonalizedAds: Bool {
        ATTrackingManager.trackingAuthorizationStatus != .authorized
    }
}
