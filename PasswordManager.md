#  Password Manager – SwiftUI

### About:-
A secure, local-first password manager app built using SwiftUI and MVVM, with 
strong encryption (AES/RSA), CoreData for local storage, and a clean, 
user-friendly interface.


### Features:-
- AES/RSA Encryption for all stored password data

- Secure CoreData Storage on device

- Intuitive SwiftUI UI for managing password entries

- Input Validation for required fields

- Robust Error Handling across app flows

- Face ID / Passcode Authentication on app launch

- Auto-lock after inactivity or backgrounding


### Requirements:-
- iOS 15.0+

- Xcode 14+

- Swift 5+

- Device Support: iPhone (Face ID or Touch ID supported)


### Clone the Repository:-
- git clone https://github.com/your-username/password-manager-swiftui.git
cd password-manager-swiftui


### Open the Project:-
- Open PasswordManager.xcodeproj in Xcode.


### Build and Run:-
- Select a simulator or real device.

- Press Cmd+R or click the Run button in Xcode.


### Features:-
- Encryption: AES for password data, RSA for secure key storage.

- Local Storage: Uses CoreData for secure and persistent password storage.

- Face ID / Touch ID: Used for authentication fallback to a secure PIN.

- Auto-Lock: Automatically locks when the app goes into background or after timeout.

- Password Details Sheet: View and securely edit stored credentials.

- Validation: Ensures required fields like website, username, and password are filled.

- Error Handling: User-friendly messages for common issues like empty fields or decryption failures.


### Using the App:-

-> On First Launch:

    - You’ll be prompted to set a master PIN.

    - Face ID (or Touch ID) is also configured as fallback authentication.


### Managing Passwords:-
- Tap ➕ Add to create a new password entry.

- Tap on an existing password to view or edit details.

- Use the search feature to quickly find entries.


### Security:-
- All passwords are stored locally and encrypted.

- App will lock automatically on background or after 30 seconds of inactivity.

