//
//  ContentView.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var securityManager: SecurityManager
    @AppStorage("useFaceID") private var useFaceID = false

    var body: some View {
        if useFaceID && !securityManager.isUnlocked {
            AuthenticationView()
        } else {
            ZStack(alignment: .bottom) {
                TabView {
                    CEListView()
                        .tabItem { Label("CE", systemImage: "book.closed") }
                    LicenseListView()
                        .tabItem { Label("License", systemImage: "doc.text") }
                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gear") }
                }

                VStack {
                    Spacer()
                    BannerAdView()
                        .frame(height: 50)
                }
                .padding(.bottom, 50) // Adjust this if needed to clear the tab bar height
            }
        }
    }
}
