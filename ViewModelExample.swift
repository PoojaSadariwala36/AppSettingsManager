import Foundation
import SwiftUI
import AppSettingsManager
import Combine

// MARK: - ViewModel with AppSettingsManager

/// Example ViewModel demonstrating best practices for using AppSettingsManager
@MainActor
class UserSettingsViewModel: ObservableObject {
    // MARK: - Published Properties for UI
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var userAge: Int = 0
    @Published var notificationsEnabled: Bool = true
    @Published var themeColor: String = "blue"
    
    // MARK: - AppSettingsManager Properties
    @AppSetting("isLoggedIn", defaultValue: false) private var storedIsLoggedIn
    @AppSetting("username", defaultValue: "") private var storedUsername
    @AppSetting("userAge", defaultValue: 0) private var storedUserAge
    @AppSetting("notificationsEnabled", defaultValue: true) private var storedNotificationsEnabled
    @AppSetting("themeColor", defaultValue: "blue") private var storedThemeColor
    
    // MARK: - Computed Properties
    var hasStoredSettings: Bool {
        return $storedIsLoggedIn.hasStoredValue || 
               $storedUsername.hasStoredValue || 
               $storedUserAge.hasStoredValue
    }
    
    // MARK: - Initialization
    init() {
        loadSettings()
    }
    
    // MARK: - Public Methods
    
    /// Load settings from UserDefaults and update published properties
    func loadSettings() {
        isLoggedIn = storedIsLoggedIn
        username = storedUsername
        userAge = storedUserAge
        notificationsEnabled = storedNotificationsEnabled
        themeColor = storedThemeColor
    }
    
    /// Save current published properties to UserDefaults
    func saveSettings() {
        storedIsLoggedIn = isLoggedIn
        storedUsername = username
        storedUserAge = userAge
        storedNotificationsEnabled = notificationsEnabled
        storedThemeColor = themeColor
    }
    
    /// Login user and save settings
    func login(username: String, age: Int) {
        self.username = username
        self.userAge = age
        self.isLoggedIn = true
        saveSettings()
    }
    
    /// Logout user and clear sensitive data
    func logout() {
        isLoggedIn = false
        username = ""
        userAge = 0
        saveSettings()
    }
    
    /// Update user profile
    func updateProfile(username: String, age: Int) {
        self.username = username
        self.userAge = age
        saveSettings()
    }
    
    /// Update notification preferences
    func updateNotifications(enabled: Bool) {
        notificationsEnabled = enabled
        saveSettings()
    }
    
    /// Update theme
    func updateTheme(_ color: String) {
        themeColor = color
        saveSettings()
    }
    
    /// Reset all settings to defaults
    func resetAllSettings() {
        $storedIsLoggedIn.reset()
        $storedUsername.reset()
        $storedUserAge.reset()
        $storedNotificationsEnabled.reset()
        $storedThemeColor.reset()
        loadSettings()
    }
    
    /// Reset only user-specific settings (keep app preferences)
    func resetUserSettings() {
        $storedIsLoggedIn.reset()
        $storedUsername.reset()
        $storedUserAge.reset()
        loadSettings()
    }
}

// MARK: - Settings Manager ViewModel

/// ViewModel for managing app-wide settings
@MainActor
class AppSettingsViewModel: ObservableObject {
    @Published var allSettings: [String: Any] = [:]
    @Published var isLoading = false
    
    private let settingsManager = AppSettingsManager()
    
    init() {
        loadAllSettings()
    }
    
    func loadAllSettings() {
        isLoading = true
        allSettings = settingsManager.userDefaults.dictionaryRepresentation()
        isLoading = false
    }
    
    func clearAllSettings() {
        settingsManager.clearAllSettings()
        loadAllSettings()
    }
    
    func removeSetting(for key: String) {
        settingsManager.removeSetting(for: key)
        loadAllSettings()
    }
}

// MARK: - SwiftUI View Examples

struct UserProfileView: View {
    @StateObject private var viewModel = UserSettingsViewModel()
    @State private var editingUsername = ""
    @State private var editingAge = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("User Profile") {
                    if viewModel.isLoggedIn {
                        HStack {
                            Text("Username:")
                            Text(viewModel.username)
                        }
                        
                        HStack {
                            Text("Age:")
                            Text("\(viewModel.userAge)")
                        }
                        
                        Button("Logout") {
                            viewModel.logout()
                        }
                        .foregroundColor(.red)
                    } else {
                        HStack {
                            TextField("Username", text: $editingUsername)
                            TextField("Age", text: $editingAge)
                                .keyboardType(.numberPad)
                        }
                        
                        Button("Login") {
                            if let age = Int(editingAge) {
                                viewModel.login(username: editingUsername, age: age)
                            }
                        }
                        .disabled(editingUsername.isEmpty || editingAge.isEmpty)
                    }
                }
                
                Section("Preferences") {
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                        .onChange(of: viewModel.notificationsEnabled) { _ in
                            viewModel.updateNotifications(enabled: viewModel.notificationsEnabled)
                        }
                    
                    Picker("Theme", selection: $viewModel.themeColor) {
                        Text("Blue").tag("blue")
                        Text("Red").tag("red")
                        Text("Green").tag("green")
                    }
                    .onChange(of: viewModel.themeColor) { _ in
                        viewModel.updateTheme(viewModel.themeColor)
                    }
                }
                
                Section("Settings") {
                    Button("Reset User Settings") {
                        viewModel.resetUserSettings()
                    }
                    .foregroundColor(.orange)
                    
                    Button("Reset All Settings") {
                        viewModel.resetAllSettings()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct SettingsDebugView: View {
    @StateObject private var viewModel = AppSettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.allSettings.keys.sorted()), id: \.self) { key in
                    HStack {
                        Text(key)
                        Spacer()
                        Text("\(viewModel.allSettings[key] ?? "nil")")
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let key = Array(viewModel.allSettings.keys.sorted())[index]
                        viewModel.removeSetting(for: key)
                    }
                }
            }
            .navigationTitle("Settings Debug")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        viewModel.clearAllSettings()
                    }
                }
            }
        }
    }
}

// MARK: - Best Practices Documentation

/*
 
 ## Why Use AppSettingsManager in ViewModels?
 
 ### 1. **Separation of Concerns**
 - ViewModels handle business logic and data management
 - Views focus on UI presentation
 - Settings are business logic, not UI logic
 
 ### 2. **Reactive Updates**
 - @Published properties automatically update UI
 - Settings changes trigger UI updates
 - Consistent state management across the app
 
 ### 3. **Testability**
 - ViewModels can be easily unit tested
 - Settings logic is isolated and mockable
 - Clear separation between UI and data layers
 
 ### 4. **Persistence**
 - Settings automatically persist across app launches
 - No need to manually save/load settings
 - Type-safe access to stored values
 
 ### 5. **Default Values**
 - Always have fallback values
 - Graceful handling of missing settings
 - No nil checks needed in UI code
 
 ## Best Practices:
 
 1. **Use @Published for UI-bound properties**
 2. **Keep AppSetting properties private**
 3. **Sync between @Published and @AppSetting in methods**
 4. **Load settings in init()**
 5. **Save settings when values change**
 6. **Use computed properties for derived state**
 7. **Group related settings in the same ViewModel**
 
 */

#if DEBUG
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

struct SettingsDebugView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDebugView()
    }
}
#endif
