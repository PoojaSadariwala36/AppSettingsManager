import Foundation
import SwiftUI
import AppSettingsManager

// MARK: - Example Usage

/// Example class demonstrating how to use AppSettingsManager
class ExampleSettings {
    // Basic usage with different data types
    @AppSetting("isLoggedIn", defaultValue: false) var isLoggedIn
    @AppSetting("username", defaultValue: "") var username
    @AppSetting("userAge", defaultValue: 0) var userAge
    @AppSetting("userScore", defaultValue: 0.0) var userScore
    @AppSetting("userData", defaultValue: Data()) var userData
    
    // Using custom UserDefaults suite
    @AppSetting("premiumFeature", defaultValue: false, userDefaults: UserDefaults(suiteName: "com.example.premium")!) var premiumFeature
    
    // SwiftUI integration
    @AppStorageSetting("themeColor", defaultValue: "blue") var themeColor
    @AppStorageSetting("notificationsEnabled", defaultValue: true) var notificationsEnabled
    
    // Example methods
    func login(username: String) {
        self.username = username
        self.isLoggedIn = true
    }
    
    func logout() {
        self.isLoggedIn = false
        self.username = ""
    }
    
    func resetSettings() {
        // Reset individual settings
        $isLoggedIn.reset()
        $username.reset()
        $userAge.reset()
        $userScore.reset()
        $userData.reset()
    }
}

// MARK: - SwiftUI Example View

struct ExampleView: View {
    @StateObject private var settings = ExampleSettings()
    @State private var newUsername = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("User Settings") {
                    Toggle("Logged In", isOn: $settings.isLoggedIn)
                    
                    HStack {
                        Text("Username:")
                        TextField("Enter username", text: $newUsername)
                        Button("Set") {
                            settings.username = newUsername
                        }
                    }
                    
                    Text("Current username: \(settings.username)")
                    
                    HStack {
                        Text("Age:")
                        TextField("Enter age", value: $settings.userAge, format: .number)
                    }
                    
                    HStack {
                        Text("Score:")
                        TextField("Enter score", value: $settings.userScore, format: .number)
                    }
                }
                
                Section("App Settings") {
                    Toggle("Notifications", isOn: $settings.notificationsEnabled)
                    
                    Picker("Theme Color", selection: $settings.themeColor) {
                        Text("Blue").tag("blue")
                        Text("Red").tag("red")
                        Text("Green").tag("green")
                    }
                }
                
                Section("Actions") {
                    Button("Login") {
                        settings.login(username: newUsername)
                    }
                    .disabled(newUsername.isEmpty)
                    
                    Button("Logout") {
                        settings.logout()
                        newUsername = ""
                    }
                    .disabled(!settings.isLoggedIn)
                    
                    Button("Reset All Settings") {
                        settings.resetSettings()
                        newUsername = ""
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings Example")
        }
    }
}

// MARK: - AppSettingsManager Usage Example

class SettingsManagerExample {
    private let settingsManager = AppSettingsManager()
    
    func demonstrateManagerFeatures() {
        // Set some values
        settingsManager.setValue("John Doe", for: "fullName")
        settingsManager.setValue(25, for: "age")
        settingsManager.setValue(true, for: "isPremium")
        
        // Get values with defaults
        let fullName = settingsManager.getValue(for: "fullName", defaultValue: "Unknown")
        let age = settingsManager.getValue(for: "age", defaultValue: 0)
        let isPremium = settingsManager.getValue(for: "isPremium", defaultValue: false)
        
        print("Full Name: \(fullName)")
        print("Age: \(age)")
        print("Is Premium: \(isPremium)")
        
        // Check if keys exist
        print("Has fullName: \(settingsManager.hasKey("fullName"))")
        print("Has nonExistent: \(settingsManager.hasKey("nonExistent"))")
        
        // Get all keys
        print("All keys: \(settingsManager.allKeys)")
        
        // Remove a specific setting
        settingsManager.removeSetting(for: "age")
        print("Age after removal: \(settingsManager.getValue(for: "age", defaultValue: 0))")
        
        // Clear all settings
        // settingsManager.clearAllSettings()
    }
}

// MARK: - Preview

#if DEBUG
struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
#endif
