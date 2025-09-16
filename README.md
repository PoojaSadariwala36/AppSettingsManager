# AppSettingsManager

A Swift package that provides convenient property wrappers for UserDefaults and AppStorage with type safety and default values.

## Features

- 🎯 **Type-safe property wrappers** for UserDefaults and SwiftUI AppStorage
- 🔧 **Default values** for all settings
- 🏗️ **Custom UserDefaults suites** support
- 📱 **SwiftUI integration** with AppStorageSetting
- 🛠️ **Additional utilities** with AppSettingsManager class
- ✅ **Multiple data types** support (Bool, String, Int, Double, Float, Data)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/PoojaSadariwala36/AppSettingsManager.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Usage

### Basic Usage

```swift
import AppSettingsManager

class Settings {
    @AppSetting("isLoggedIn", defaultValue: false) var isLoggedIn
    @AppSetting("username", defaultValue: "") var username
    @AppSetting("userAge", defaultValue: 0) var userAge
    @AppSetting("userScore", defaultValue: 0.0) var userScore
}
```

### SwiftUI Integration

```swift
import SwiftUI
import AppSettingsManager

struct ContentView: View {
    @AppStorageSetting("themeColor", defaultValue: "blue") var themeColor
    @AppStorageSetting("notificationsEnabled", defaultValue: true) var notificationsEnabled
    
    var body: some View {
        VStack {
            Toggle("Notifications", isOn: $notificationsEnabled)
            Picker("Theme", selection: $themeColor) {
                Text("Blue").tag("blue")
                Text("Red").tag("red")
            }
        }
    }
}
```

### Custom UserDefaults Suite

```swift
let premiumDefaults = UserDefaults(suiteName: "com.yourapp.premium")!

class PremiumSettings {
    @AppSetting("premiumFeature", defaultValue: false, userDefaults: premiumDefaults) var premiumFeature
}
```

### AppSettingsManager Utilities

```swift
let settingsManager = AppSettingsManager()

// Set values
settingsManager.setValue("John Doe", for: "fullName")
settingsManager.setValue(25, for: "age")

// Get values with defaults
let fullName = settingsManager.getValue(for: "fullName", defaultValue: "Unknown")

// Check if key exists
let hasName = settingsManager.hasKey("fullName")

// Get all keys
let allKeys = settingsManager.allKeys

// Remove specific setting
settingsManager.removeSetting(for: "age")

// Clear all settings
settingsManager.clearAllSettings()
```

### Property Wrapper Features

```swift
class MySettings {
    @AppSetting("isLoggedIn", defaultValue: false) var isLoggedIn
    
    func resetLogin() {
        // Reset to default value
        $isLoggedIn.reset()
    }
    
    func checkIfStored() {
        // Check if value is stored (not using default)
        if $isLoggedIn.hasStoredValue {
            print("User has a stored login preference")
        }
    }
}
```

## API Reference

### AppSetting<T>

A property wrapper for UserDefaults with type safety and default values.

**Initializer:**
```swift
init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard)
```

**Properties:**
- `wrappedValue: T` - The current value
- `projectedValue: AppSetting<T>` - Access to utility methods

**Methods:**
- `reset()` - Reset to default value
- `hasStoredValue: Bool` - Check if value is stored

### AppStorageSetting<T>

A property wrapper for SwiftUI AppStorage integration.

**Initializer:**
```swift
init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard)
```

**Properties:**
- `wrappedValue: T` - The current value
- `projectedValue: AppStorageSetting<T>` - Access to utility methods

**Methods:**
- `reset()` - Reset to default value
- `hasStoredValue: Bool` - Check if value is stored

### AppSettingsManager

A utility class for managing app settings.

**Methods:**
- `setValue<T>(_ value: T, for key: String)` - Set a value
- `getValue<T>(for key: String, defaultValue: T) -> T` - Get a value with default
- `hasKey(_ key: String) -> Bool` - Check if key exists
- `removeSetting(for key: String)` - Remove a setting
- `clearAllSettings()` - Clear all settings
- `allKeys: [String]` - Get all stored keys

## Supported Data Types

- `Bool`
- `String`
- `Int`
- `Double`
- `Float`
- `Data`
- Any type that conforms to `UserDefaults` storage requirements

## Requirements

- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+
- Swift 5.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Example

See the `Example.swift` file for a complete working example demonstrating all features.
