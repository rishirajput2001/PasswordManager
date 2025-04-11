//
//  HiddenTextField.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

struct HiddenTextField: UIViewRepresentable {
    
    @Binding var text: String
    var onComplete: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.delegate = context.coordinator
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onComplete: onComplete)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onComplete: () -> Void

        init(text: Binding<String>, onComplete: @escaping () -> Void) {
            _text = text
            self.onComplete = onComplete
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text as NSString? else { return false }
            let updated = currentText.replacingCharacters(in: range, with: string)
            if updated.count <= 4 {
                text = updated
                if updated.count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.onComplete()
                    }
                }
            }
            return updated.count <= 4
        }
    }
}

