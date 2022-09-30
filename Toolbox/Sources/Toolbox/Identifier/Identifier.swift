import Foundation

public struct Identifier<T>: Hashable, Codable, ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(from decoder: Decoder) throws {
        self.rawValue = try StringLiteralType(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension Identifier {
    public init(_ value: String = UUID().uuidString) {
        self.rawValue = value
    }
}
