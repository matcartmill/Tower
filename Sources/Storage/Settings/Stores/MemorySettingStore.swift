import Foundation

public class MemorySettingStore: SettingStore {
    private let queue = DispatchQueue(label: "tower.settings.in-memory")
    private var settings: [String: Any] = [:]
    
    public init() { }
    
    public func update<T>(_ setting: Setting<T>, to: T?) {
        queue.sync {
            settings[setting.key] = to
        }
    }
    
    public func value<T>(for setting: Setting<T>) -> T? {
        var value: T?
        
        queue.sync {
            value = settings[setting.key] as? T ?? setting.defaultValue
        }
        
        return value
    }
    
    public func remove<T>(_ setting: Setting<T>) {
        queue.sync {
            settings[setting.key] = nil
        }
    }
    
    public func removeAll() {
        queue.sync {
            settings.removeAll()
        }
    }
}
