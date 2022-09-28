import Foundation

public struct HTTPMethod: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HTTPMethod {
    public static var get: Self { .init(rawValue: "GET") }
    public static var post: Self { .init(rawValue: "POST") }
    public static var patch: Self { .init(rawValue: "PATCH") }
    public static var put: Self { .init(rawValue: "PUT") }
    public static var delete: Self { .init(rawValue: "DELETE") }
}
