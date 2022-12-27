import Foundation

public struct Setting<T: Codable> {
    public let key: String
    public let defaultValue: T?
    
    public init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
