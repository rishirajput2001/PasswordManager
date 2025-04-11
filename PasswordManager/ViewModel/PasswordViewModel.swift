//
//  PasswordViewModel.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import Foundation
import CoreData

class PasswordViewModel: ObservableObject {
    @Published var passwordItems: [PasswordItem] = []
    @Published var selectedPassword: PasswordEntity?

    let context = PersistenceController.shared.container.viewContext

    init() {
        fetchPasswords()
    }

    func fetchPasswords() {
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            passwordItems = results.map {
                PasswordItem(serviceName: $0.accountName ?? "")
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    func addPassword(account: String, username: String, password: String) {
        guard !account.isEmpty, !username.isEmpty, !password.isEmpty else { return }

        let newEntry = PasswordEntity(context: context)
        newEntry.id = UUID()
        newEntry.accountName = account
        newEntry.username = username
        newEntry.password = EncryptionHelper.encrypt(password)
        newEntry.createdAt = Date()

        do {
            try context.save()
            fetchPasswords()
            
        } catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    func updatePassword(entity: PasswordEntity, account: String, username: String, password: String) {
        entity.accountName = account
        entity.username = username
        entity.password = EncryptionHelper.encrypt(password)

        do {
            try context.save()
            fetchPasswords()
        } catch {
            print("Update failed: \(error.localizedDescription)")
        }
    }

    func deletePassword(entity: PasswordEntity) {
        context.delete(entity)
        do {
            try context.save()
            fetchPasswords()
        } catch {
            print("Delete failed: \(error.localizedDescription)")
        }
    }
}
