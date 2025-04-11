//
//  Color+Extention.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        var hexNumber: UInt64 = 0
        if scanner.scanString("#", into: nil) { }
        scanner.scanHexInt64(&hexNumber)

        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
