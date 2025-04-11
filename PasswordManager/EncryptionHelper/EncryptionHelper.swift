//
//  EncryptionHelper.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import Foundation
import CryptoKit

struct EncryptionHelper {
    private static var key: SymmetricKey = {
        if let base64Key = UserDefaults.standard.string(forKey: "encryption_key"),
           let keyData = Data(base64Encoded: base64Key) {
            return SymmetricKey(data: keyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            let keyData = newKey.withUnsafeBytes { Data(Array($0)) }
            let base64Key = keyData.base64EncodedString()
            UserDefaults.standard.set(base64Key, forKey: "encryption_key")
            return newKey
        }
    }()

    static func encrypt(_ text: String) -> String {
        let data = text.data(using: .utf8)!
        let sealedBox = try! AES.GCM.seal(data, using: key)
        return sealedBox.combined!.base64EncodedString()
    }

    static func safeDecrypt(_ base64: String?) -> String {
        guard let base64 = base64, !base64.isEmpty else { return "" }

        guard let data = Data(base64Encoded: base64) else {
            print("Invalid base64")
            return ""
        }

        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8) ?? "********"
        } catch {
            print("Decryption error: \(error)")
            return ""
        }
    }
}
