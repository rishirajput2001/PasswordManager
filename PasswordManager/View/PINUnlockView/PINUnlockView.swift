//
//  PINUnlockView.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

struct PINUnlockView: View {
    
    @AppStorage("savedPasscode") var savedPasscode = ""
    @Binding var isUnlocked: Bool

    @State private var input = ""
    @State private var error = false

    private let passcodeLength = 4

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Enter Passcode")
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack(spacing: 20) {
                    ForEach(0..<passcodeLength, id: \.self) { index in
                        Circle()
                            .fill(index < input.count ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 16, height: 16)
                    }
                }

                if error {
                    Text("Incorrect Passcode")
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }
            .onTapGesture {
                // Trigger hidden keyboard when user taps anywhere
                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
            }

            HiddenTextField(text: $input, onComplete: checkPasscode)
                .frame(width: 0, height: 0)
                .opacity(0)
        }
    }

    func checkPasscode() {
        if input == savedPasscode {
            isUnlocked = true
        } else {
            withAnimation {
                error = true
                input = ""
            }
        }
    }
}




