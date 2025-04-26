//
//  SecurityManager.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//


import Foundation
import LocalAuthentication

class SecurityManager: ObservableObject {
    @Published var isUnlocked = false

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock CE Wallet"
            ) { success, _ in
                DispatchQueue.main.async {
                    self.isUnlocked = success
                }
            }
        } else {
            // Fallback to unlocking if no biometrics
            DispatchQueue.main.async {
                self.isUnlocked = true
            }
        }
    }
}
