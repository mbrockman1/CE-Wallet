//
//  AnalyticsManager.swift
//  CEWallet
//

import Foundation
import FirebaseAnalytics

/// Thin wrapper around Firebase Analytics (Google Analytics 4).
/// The Firebase project backing this app already reports into a GA4 property —
/// this type is the single place the rest of the app talks to it, and the
/// single place a user's analytics opt-out is enforced.
final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}

    /// Persisted opt-out, exposed in Settings. Defaults to enabled since this
    /// SDK variant (FirebaseAnalyticsWithoutAdIdSupport) does not collect IDFA.
    static let collectionEnabledKey = "analyticsCollectionEnabled"

    var isCollectionEnabled: Bool {
        UserDefaults.standard.object(forKey: Self.collectionEnabledKey) as? Bool ?? true
    }

    /// Call once at launch to apply whatever the user last chose.
    func applyStoredConsent() {
        Analytics.setAnalyticsCollectionEnabled(isCollectionEnabled)
    }

    func setCollectionEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Self.collectionEnabledKey)
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    func logScreenView(_ screenName: String, screenClass: String? = nil) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass ?? screenName,
        ])
    }

    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

/// App-specific event names, kept in one place so callers don't hand-roll strings.
enum AnalyticsEvent {
    static let ceEntryAdded = "ce_entry_added"
    static let ceEntryDeleted = "ce_entry_deleted"
    static let licenseAdded = "license_added"
    static let licenseDeleted = "license_deleted"
    static let pdfExported = "pdf_exported"
}
