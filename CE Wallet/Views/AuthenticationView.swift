//
//  AuthenticationView.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//


import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var securityManager: SecurityManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Unlock CE Wallet")
                .font(.title2)
            Button("Use Face ID") {
                securityManager.authenticate()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            securityManager.authenticate()
        }
    }
}
