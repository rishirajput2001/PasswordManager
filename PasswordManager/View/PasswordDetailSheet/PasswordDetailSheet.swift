//
//  PasswordDetailSheet.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

struct PasswordDetailSheet: View {

    let passwordEntity: PasswordEntity
    @ObservedObject var viewModel: PasswordViewModel
    @Environment(\.dismiss) var dismiss

    @State private var isEditing = false
    @State private var showPassword = false

    @State private var accountName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

    @State private var accountNameError = ""
    @State private var usernameError = ""
    @State private var passwordError = ""

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top)

            Text("Account Details")
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Account Type")
                        .font(.caption)
                        .foregroundColor(.gray)

                    TextField("", text: $accountName)
                        .disabled(!isEditing)
                        .font(.custom("Poppins-Regular", size: 16))
                        .background(Color.clear)

                    if !accountNameError.isEmpty {
                        Text(accountNameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Username/ Email")
                        .font(.caption)
                        .foregroundColor(.gray)

                    TextField("", text: $username)
                        .disabled(!isEditing)
                        .font(.custom("Poppins-Regular", size: 16))
                        .background(Color.clear)

                    if !usernameError.isEmpty {
                        Text(usernameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack {
                        if showPassword {
                            TextField("", text: $password)
                        } else {
                            SecureField("", text: $password)
                        }

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                        }
                    }
                    .disabled(!isEditing)

                    if isEditing {
                        PasswordStrengthView(password: password)
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
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    if isEditing {
                        if validateFields() {
                            viewModel.updatePassword(entity: passwordEntity, account: accountName, username: username, password: password)
                            isEditing = false
                            dismiss()
                        }
                    } else {
                        isEditing = true
                    }
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .foregroundColor(.white)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.black)
                        .cornerRadius(22)
                }

                Button(action: {
                    isEditing = false
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.deletePassword(entity: passwordEntity)
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .cornerRadius(22)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                accountName = passwordEntity.accountName ?? ""
                username = passwordEntity.username ?? ""
                password = EncryptionHelper.safeDecrypt(passwordEntity.password ?? "")
            }
        }
    }

    // MARK: - Validation
    private func validateFields() -> Bool {
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
            passwordError = "Password must be at least 8 characters long and include at least 1 number, and 1 special character."
        } else {
            passwordError = ""
        }

        return accountNameError.isEmpty && usernameError.isEmpty && passwordError.isEmpty
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>~`\\/\[\];'=+\-_]).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: password)
    }
}


// MARK: - Password Strength Meter View
struct PasswordStrengthView: View {
    var password: String

    var strength: (color: Color, label: String) {
        if password.count < 8 { return (.red, "Too short") }
        let hasLetters = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
        let hasNumbers = password.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecials = password.range(of: "[!@#$%^&*(),.?\":{}|<>~`\\[\\];'=+\\-_]", options: .regularExpression) != nil

        switch (hasLetters, hasNumbers, hasSpecials) {
        case (true, true, true): return (.green, "Strong")
        case (true, true, false): return (.yellow, "Medium")
        default: return (.orange, "Weak")
        }
    }

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(strength.color)
                .frame(width: 100, height: 6)
            Text(strength.label)
                .font(.caption)
                .foregroundColor(strength.color)
        }
        .animation(.easeInOut, value: password)
    }
}

// MARK: - Password Generator
struct PasswordGenerator {
    static func generate(length: Int = 16) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/"
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }
}
