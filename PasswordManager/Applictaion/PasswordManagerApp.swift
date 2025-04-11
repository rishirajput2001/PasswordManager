//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI

@main
struct PasswordManagerApp: App {
    
    let persistenceController = PersistenceController.shared
    @AppStorage("hasPasscode") var hasPasscode = false
    @State private var isUnlocked = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !hasPasscode {
                    SetPasscodeView()
                } else if isUnlocked {
                    HomeView()
                } else {
                    AppLockView(isUnlocked: $isUnlocked)
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}




