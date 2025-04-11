//
//  AddPasswordSheet.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

struct AddPasswordSheet: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PasswordViewModel

    @State private var accountName = ""
    @State private var username = ""
    @State private var password = ""

    @State private var accountNameError = ""
    @State private var usernameError = ""
    @State private var passwordError = ""

    @State private var passwordStrength: PasswordStrength = .weak

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top)

            // Account Name Field
            VStack(alignment: .leading, spacing: 4) {
                TextField("Account Name", text: $accountName)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 44)
                    .font(.custom("Roboto-VariableFont_wdth,wght", size: 16))
                if !accountNameError.isEmpty {
                    Text(accountNameError)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            // Username Field
            VStack(alignment: .leading, spacing: 4) {
                TextField("Username / Email", text: $username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 44)
                    .font(.custom("Roboto-VariableFont_wdth,wght", size: 16))
                if !usernameError.isEmpty {
                    Text(usernameError)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            // Password Field + Strength + Generator
            VStack(alignment: .leading, spacing: 8) {
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 44)
                    .font(.custom("Roboto-VariableFont_wdth,wght", size: 16))
                    .onChange(of: password) { _ in
                        passwordStrength = PasswordStrength.evaluate(password)
                    }

                if !password.isEmpty {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(strengthColor)
                            .frame(width: 80, height: 6)
                        Text(strengthText)
                            .font(.caption)
                            .foregroundColor(strengthColor)
                    }
                }

                if !passwordError.isEmpty {
                    Text(passwordError)
                        .font(.caption)
                        .foregroundColor(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 2)
                }
            }

            Spacer()

            Button(action: {
                validateFields()
            }) {
                Text("Add New Account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 12)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)
                    .padding(.top, 20)
                    .font(.custom("Poppins-SemiBold", size: 16))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    // MARK: - Validation
    private func validateFields() {
        accountNameError = accountName.isEmpty ? "Account name is required." : ""

        if username.isEmpty {
            usernameError = "Username or email is required."
        } else if !isValidEmail(username) {
            usernameError = "Please enter a valid email address."
        } else {
            usernameError = ""
        }

        if password.isEmpty {
            passwordError = "Password is required."
        } else if !isValidPassword(password) {
            passwordError = "Password must be at least 8 characters long and include at least 1 number and 1 special character."
        } else {
            passwordError = ""
        }

        let isValid = accountNameError.isEmpty && usernameError.isEmpty && passwordError.isEmpty

        if isValid {
            viewModel.addPassword(account: accountName, username: username, password: password)
            dismiss()
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>~`\\/\[\];'=+\-_]).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: password)
    }

    private func generateRandomPassword(length: Int = 16) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:',.<>?/"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }

    private var strengthColor: Color {
        switch passwordStrength {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }

    private var strengthText: String {
        switch passwordStrength {
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        }
    }

    enum PasswordStrength {
        case weak, medium, strong

        static func evaluate(_ password: String) -> PasswordStrength {
            let length = password.count
            let hasLetters = NSPredicate(format: "SELF MATCHES %@", ".*[A-Za-z]+.*").evaluate(with: password)
            let hasDigits = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
            let hasSymbols = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>~`\\[\\];'=+\\-_/].*").evaluate(with: password)

            if length >= 12 && hasLetters && hasDigits && hasSymbols {
                return .strong
            } else if length >= 8 && ((hasLetters && hasDigits) || (hasLetters && hasSymbols)) {
                return .medium
            } else {
                return .weak
            }
        }
    }
}
