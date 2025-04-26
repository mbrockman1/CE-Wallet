//
//  ContentView.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CEListView()
                .tabItem { Label("CE", systemImage: "book.closed") }
            LicenseListView()
                .tabItem { Label("License", systemImage: "doc.text") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
