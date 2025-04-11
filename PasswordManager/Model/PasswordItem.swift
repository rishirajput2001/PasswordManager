//
//  PasswordItem.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import Foundation

struct PasswordItem: Identifiable {
    let id = UUID()
    let serviceName: String
    let maskedPassword: String = "******"
}

