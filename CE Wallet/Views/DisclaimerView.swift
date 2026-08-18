//
//  DisclaimerView.swift
//  CEWallet
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("CE Wallet is provided for informational and organizational purposes only. It is not intended to replace professional judgment, examination, diagnosis, or treatment.")

                Text("The app does not provide medical advice. Always consult a qualified healthcare provider for diagnosis and treatment of any medical condition.")

                Text("While we strive to keep content accurate and up to date, CE Wallet makes no warranties or representations of any kind, express or implied, regarding the completeness, accuracy, reliability, or availability of the app or the content therein.")

                Text("Under no circumstances shall CE Wallet developers, affiliates, or contributors be liable for any direct, indirect, incidental, consequential, or punitive damages arising out of your access to or use of the app, even if advised of the possibility of such damages.")

                Text("By using CE Wallet, you agree that you assume full responsibility for any use of the information contained within and waive any and all claims against the developers.")

                Text("This disclaimer applies to all functionality including but not limited to educational tracking, certificate storage, and notifications. See Terms of Service for full details.")
            }
            .padding()
        }
        .navigationTitle("Disclaimer")
    }
}

struct AboutMeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("The Developer")
                    .font(.title)
                    .bold()

                Text("CE Wallet is developed and maintained by a lean, independent team with a strong foundation in the medical field. Drawing from firsthand experience with continuing medical education (CME), I built CE Wallet to serve not only healthcare professionals, but anyone in a field that requires ongoing education and license management. My goal is to deliver a seamless, reliable tool that evolves with your needs. I release updates regularly, respond quickly to user feedback, and am committed to building features that make your professional life easier.")

                Divider()

                Text("How to Submit Feedback")
                    .font(.title2)
                    .bold()

                Text("I welcome all feedback — whether it's a review, bug report, or feature request. Here's how you can share your thoughts:")

                VStack(alignment: .leading, spacing: 8) {
                    Text("1. Open the App Store.")
                    Text("2. Search for \"CE Wallet\" or find it in your Purchased apps.")
                    Text("3. Scroll down to the \"Ratings & Reviews\" section.")
                    Text("4. Tap \"Write a Review\" to leave your feedback or request a feature.")
                }

                Text("Your suggestions help shape CE Wallet. Thank you for supporting this project!")
                    .padding(.top, 12)
            }
            .padding()
        }
        .navigationTitle("About & Feedback")
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DisclaimerView()
        }
    }
}
