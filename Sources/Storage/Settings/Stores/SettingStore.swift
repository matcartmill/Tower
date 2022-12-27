public protocol SettingStore {
    func update<T>(_ setting: Setting<T>, to: T?)
    func value<T>(for setting: Setting<T>) -> T?
    func remove<T>(_ setting: Setting<T>)
    func removeAll()
}
