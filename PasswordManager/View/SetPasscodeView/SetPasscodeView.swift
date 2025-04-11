//
//  SetPasscodeView.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

struct SetPasscodeView: View {
    
    @AppStorage("hasPasscode") var hasPasscode = false
    @AppStorage("savedPasscode") var savedPasscode = ""

    @State private var passcode = ""

    private let passcodeLength = 4

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Set a 4-digit Passcode")
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack(spacing: 20) {
                    ForEach(0..<passcodeLength, id: \.self) { index in
                        Circle()
                            .fill(index < passcode.count ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 16, height: 16)
                    }
                }

                if passcode.count == passcodeLength {
                    Text("Saving...").foregroundColor(.gray)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
            }

            HiddenTextField(text: $passcode, onComplete: savePasscode)
                .frame(width: 0, height: 0)
                .opacity(0)
        }
    }

    func savePasscode() {
        if passcode.count == passcodeLength {
            savedPasscode = passcode
            hasPasscode = true
        }
    }
}


