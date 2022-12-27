import Foundation

public struct KeychainStoreSettings {
    public struct Accessibility {
        public let accessibility: String
        public let synchronizable: Bool

        /// Creates a `KeychainStoreSettings.Accessibility` item.
        ///
        /// - Parameters:
        ///   - accessbility: The accessibility settings for this value in the Keychain. See: https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679100
        ///   - synchronizable: A flag indicating whether or not an item added should be made synchronizable through iCloud. Certain accessibility types are not allowed when this flag is set to `true`, namely those ending in `ThisDeviceOnly`.
        init(accessibility: String, synchronizable: Bool) {
            self.accessibility = accessibility
            self.synchronizable = synchronizable
        }
    }

    public let service: String
    public let accessGroup: KeychainAccessGroup
    public let accessibility: Accessibility

    /// Creates a `KeychainItem`.
    ///
    /// - Parameters:
    ///   - service: A way to differentiate between identical keys for different services.
    ///   - accessGroup: The name of the access group for this store. See: https://developer.apple.com/documentation/security/ksecattraccessgroup
    ///   - accessbility: A `KeychainStoreSettings.Accessibility` value that dictates how the Store persists data and with which security read settings.
    public init(service: String, accessGroup: KeychainAccessGroup, accessibility: Accessibility) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
    }
}

public extension KeychainStoreSettings.Accessibility {
    static func afterFirstUnlock(synchronizable: Bool) -> KeychainStoreSettings.Accessibility {
        return .init(accessibility: kSecAttrAccessibleAfterFirstUnlock as String, synchronizable: synchronizable)
    }
    static func whenUnlocked(synchronizable: Bool) -> KeychainStoreSettings.Accessibility {
        return .init(accessibility: kSecAttrAccessibleWhenUnlocked as String, synchronizable: synchronizable)
    }

    static var afterFirstUnlockThisDeviceOnly: KeychainStoreSettings.Accessibility {
        return .init(accessibility: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String, synchronizable: false)
    }
    static var whenUnlockedThisDeviceOnly: KeychainStoreSettings.Accessibility {
        return .init(accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String, synchronizable: false)
    }
    static var whenPasscodeSetThisDeviceOnly: KeychainStoreSettings.Accessibility {
        return .init(accessibility: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String, synchronizable: false)
    }
}

/// For use with a `KeychainItem` to set the `kSecAttrAccessGroup` value. This value determines what `Keychain` group to store the item in. For shared keychain items, please use `KeychainItemAccessGroup.shared`.
public struct KeychainAccessGroup: RawRepresentable, Equatable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension KeychainAccessGroup {
    static func shared(teamId: String) -> KeychainAccessGroup { .init(rawValue: "\(teamId).io.towerapp.shared") }
}

/// A  persistence layer that uses Apple's `Keychain` to store data.
public class KeychainSettingStore: SettingStore {

    // MARK: - Private properties

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let settings: KeychainStoreSettings

    // MARK: - Lifecycle

    public init(
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init(),
        settings: KeychainStoreSettings
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.settings = settings
    }

    // MARK: - Public

    public func remove<T>(_ setting: Setting<T>) {
        let existing = value(for: setting)
        SecItemDelete(commonAttributes(for: setting.key) as CFDictionary)
    }

    public func removeAll() {
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]

        for itemClass in secItemClasses {
            let spec: NSDictionary = [
                kSecClass: itemClass,
                kSecAttrService: settings.service
            ]
            SecItemDelete(spec)
        }
    }

    public func update<T>(_ setting: Setting<T>, to value: T?) {
        if let value = value {
            guard let data = try? encoder.encode(value) else { return }
            
            var attributes = commonAttributes(for: setting.key)
            attributes[kSecAttrAccessible as String] = settings.accessibility.accessibility

            if retrieveExisting(setting) == nil {
                attributes[kSecValueData as String] = data
                SecItemAdd(attributes as NSDictionary, nil)
            } else {
                SecItemUpdate(
                    commonAttributes(for: setting.key) as NSDictionary,
                    [kSecValueData: data] as NSDictionary
                )
            }
        } else {
            remove(setting)
        }
    }

    public func value<T>(for setting: Setting<T>) -> T? {
        return retrieveExisting(setting) ?? setting.defaultValue
    }

    // MARK: - Private
    private func commonAttributes(for key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: settings.service
        ]
    }

    private func retrieveExisting<T>(_ setting: Setting<T>) -> T? {
        var result: AnyObject?

        var attributes = commonAttributes(for: setting.key)
        attributes[kSecReturnData as String] = true

        let status = SecItemCopyMatching(attributes as NSDictionary, &result)

        guard
            status == errSecSuccess,
            let data = result as? Data,
            let item = try? decoder.decode(T.self, from: data)
        else { return nil }

        return item
    }
}
