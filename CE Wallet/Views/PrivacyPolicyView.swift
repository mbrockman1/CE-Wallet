//
//  PrivacyPolicyView.swift
//  CEWallet
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Effective Date: August 18, 2026")
                Text("Last Updated: August 18, 2026")

                Group {
                    Text("1. Information We Collect")
                        .font(.headline)
                    Text("CE Wallet collects the following information:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Analytics: App usage data (screen views, feature interactions) via Firebase Analytics")
                        Text("• Local Data: Your CE entries, licenses, and attachments stored on your device")
                    }
                    Text("\nCE Wallet does not use the App Tracking Transparency framework and does not track you across other companies' apps or websites.")

                    Text("2. How We Use Your Information")
                        .font(.headline)
                    Text("We use this information to:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Understand how you use CE Wallet (feature adoption, retention)")
                        Text("• Improve app performance and stability")
                        Text("• Serve non-personalized ads via Google AdMob")
                        Text("• Comply with legal obligations")
                    }

                    Text("3. Analytics")
                        .font(.headline)
                    Text("CE Wallet uses Firebase Analytics (Google's analytics platform) to record:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Screen views (which sections you visit)")
                        Text("• Entry creation and deletion")
                        Text("• PDF exports")
                        Text("• Your analytics consent preference")
                    }
                    Text("\nWe do NOT collect your Identifier for Advertisers (IDFA) and do NOT build profiles of your health data.")

                    Text("4. Advertising")
                        .font(.headline)
                    Text("CE Wallet shows banner ads via Google AdMob. All ads are served as non-personalized ads — CE Wallet does not request tracking permission and does not link ad requests to your identity.")

                    Text("5. Analytics Opt-Out")
                        .font(.headline)
                    Text("You can disable analytics collection anytime:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. Open CE Wallet")
                        Text("2. Go to Settings")
                        Text("3. Toggle \"Allow Analytics\" OFF")
                    }
                    Text("\nWhen disabled, no analytics events are sent to Google Firebase.")

                    Text("6. Data Storage & Retention")
                        .font(.headline)
                    Text("• Local data (CE entries, licenses): Stored on your device in SwiftData and backed up to iCloud")
                    Text("• Analytics data: Retained by Firebase for 90 days (per Google's default retention policy)")
                    Text("• We do not store your data on our servers")

                    Text("7. Third-Party Services")
                        .font(.headline)
                    Text("CE Wallet uses:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Firebase Analytics: https://firebase.google.com/support/privacy")
                        Text("• Google Mobile Ads: https://policies.google.com/technologies/ads")
                        Text("• iCloud: For backup and sync (Apple's privacy policy applies)")
                    }

                    Text("8. Your Rights")
                        .font(.headline)
                    Text("You have the right to:")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Access, correct, or delete your local data (delete entries in the app)")
                        Text("• Opt out of analytics (Settings > Privacy toggle)")
                        Text("• Request data deletion (contact the developer)")
                    }

                    Text("9. Children's Privacy")
                        .font(.headline)
                    Text("CE Wallet is intended for healthcare professionals and continuing education participants (age 18+). We do not knowingly collect data from children under 13.")

                    Text("10. Changes to This Policy")
                        .font(.headline)
                    Text("We may update this Privacy Policy anytime. Continued use of CE Wallet after updates constitutes acceptance of the revised policy.")

                    Text("11. Contact Us")
                        .font(.headline)
                    Text("For privacy questions or data deletion requests, please contact the developer via App Store reviews or the app's support channel.")
                }

                Text("© 2026 Michael Brockman. All rights reserved.")
                    .padding(.top)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}
