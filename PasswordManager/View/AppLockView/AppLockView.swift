//
//  AppLockView.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI
import LocalAuthentication

struct AppLockView: View {
    @Binding var isUnlocked: Bool
    @State private var showPIN = false

    var body: some View {
        VStack {
            if showPIN {
                PINUnlockView(isUnlocked: $isUnlocked)
            } else {
                Button("Unlock with Face ID / Touch ID") {
                    authenticateWithBiometrics()
                }
                .padding()
                .onAppear {
                    authenticateWithBiometrics()
                }
            }
        }
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock your secure vault"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        showPIN = true
                    }
                }
            }
        } else {
            showPIN = true
        }
    }
}
