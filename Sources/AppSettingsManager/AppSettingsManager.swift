import Foundation
import SwiftUI

// MARK: - AppSetting Property Wrapper for UserDefaults

/// A property wrapper that provides easy access to UserDefaults with type safety and default values.
/// 
/// Example usage:
/// ```swift
/// @AppSetting("isLoggedIn", defaultValue: false) var isLoggedIn
/// @AppSetting("username", defaultValue: "") var username
/// @AppSetting("userAge", defaultValue: 0) var userAge
/// ```
@propertyWrapper
public struct AppSetting<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    
    /// Initialize the AppSetting property wrapper
    /// - Parameters:
    ///   - key: The key to use for storing the value in UserDefaults
    ///   - defaultValue: The default value to return if no value is stored
    ///   - userDefaults: The UserDefaults instance to use (defaults to .standard)
    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) as? T else {
                return defaultValue
            }
            return value
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
    
    public var projectedValue: AppSetting<T> {
        return self
    }
    
    /// Reset the setting to its default value
    public func reset() {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Check if the setting has a stored value (not using default)
    public var hasStoredValue: Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

// MARK: - AppStorage Property Wrapper for SwiftUI

/// A property wrapper that provides easy access to UserDefaults with SwiftUI integration.
/// This is a convenience wrapper around SwiftUI's AppStorage with additional features.
/// 
/// Example usage:
/// ```swift
/// @AppStorageSetting("isLoggedIn", defaultValue: false) var isLoggedIn
/// @AppStorageSetting("username", defaultValue: "") var username
/// ```
@propertyWrapper
public struct AppStorageSetting<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    
    /// Initialize the AppStorageSetting property wrapper
    /// - Parameters:
    ///   - key: The key to use for storing the value in UserDefaults
    ///   - defaultValue: The default value to return if no value is stored
    ///   - userDefaults: The UserDefaults instance to use (defaults to .standard)
    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) as? T else {
                return defaultValue
            }
            return value
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
    
    public var projectedValue: AppStorageSetting<T> {
        return self
    }
    
    /// Reset the setting to its default value
    public func reset() {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Check if the setting has a stored value (not using default)
    public var hasStoredValue: Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

// MARK: - Type-Safe AppSetting Extensions

/// Extension to provide type-safe access for common data types
public extension AppSetting where T == Bool {
    init(_ key: String, defaultValue: Bool = false, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppSetting where T == String {
    init(_ key: String, defaultValue: String = "", userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppSetting where T == Int {
    init(_ key: String, defaultValue: Int = 0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppSetting where T == Double {
    init(_ key: String, defaultValue: Double = 0.0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppSetting where T == Float {
    init(_ key: String, defaultValue: Float = 0.0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppSetting where T == Data {
    init(_ key: String, defaultValue: Data = Data(), userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

// MARK: - Type-Safe AppStorageSetting Extensions

public extension AppStorageSetting where T == Bool {
    init(_ key: String, defaultValue: Bool = false, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppStorageSetting where T == String {
    init(_ key: String, defaultValue: String = "", userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppStorageSetting where T == Int {
    init(_ key: String, defaultValue: Int = 0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppStorageSetting where T == Double {
    init(_ key: String, defaultValue: Double = 0.0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppStorageSetting where T == Float {
    init(_ key: String, defaultValue: Float = 0.0, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public extension AppStorageSetting where T == Data {
    init(_ key: String, defaultValue: Data = Data(), userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

// MARK: - AppSettingsManager Class

/// A manager class that provides additional functionality for managing app settings
public class AppSettingsManager {
    private let userDefaults: UserDefaults
    
    /// Initialize with a specific UserDefaults instance
    /// - Parameter userDefaults: The UserDefaults instance to use (defaults to .standard)
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// Clear all settings for the current UserDefaults suite
    public func clearAllSettings() {
        let dictionary = userDefaults.dictionaryRepresentation()
        for key in dictionary.keys {
            userDefaults.removeObject(forKey: key)
        }
    }
    
    /// Get all stored keys
    public var allKeys: [String] {
        return Array(userDefaults.dictionaryRepresentation().keys)
    }
    
    /// Check if a key exists in UserDefaults
    /// - Parameter key: The key to check
    /// - Returns: True if the key exists, false otherwise
    public func hasKey(_ key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    /// Remove a specific setting
    /// - Parameter key: The key to remove
    public func removeSetting(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Get the value for a key with a default fallback
    /// - Parameters:
    ///   - key: The key to retrieve
    ///   - defaultValue: The default value if key doesn't exist
    /// - Returns: The stored value or default value
    public func getValue<T>(for key: String, defaultValue: T) -> T {
        guard let value = userDefaults.object(forKey: key) as? T else {
            return defaultValue
        }
        return value
    }
    
    /// Set a value for a key
    /// - Parameters:
    ///   - value: The value to store
    ///   - key: The key to store the value under
    public func setValue<T>(_ value: T, for key: String) {
        userDefaults.set(value, forKey: key)
    }
}

// MARK: - Convenience Extensions

/// Extension to provide convenient access to AppSettingsManager
public extension UserDefaults {
    /// Get an AppSettingsManager instance for this UserDefaults
    var settingsManager: AppSettingsManager {
        return AppSettingsManager(userDefaults: self)
    }
}