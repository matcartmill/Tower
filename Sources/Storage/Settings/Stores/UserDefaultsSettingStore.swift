import Foundation

public class UserDefaultsSettingStore: SettingStore {
    private let defaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }
    
    public func update<T>(_ setting: Setting<T>, to: T?) {
        defaults.set(to, forKey: setting.key)
    }
    
    public func value<T>(for setting: Setting<T>) -> T? {
        defaults.value(forKey: setting.key) as? T ?? setting.defaultValue
    }
    
    public func remove<T>(_ setting: Setting<T>) {
        defaults.removeObject(forKey: setting.key)
    }
    
    public func removeAll() {
        assertionFailure("Not possible to clear all user defaults yet.")
    }
}
