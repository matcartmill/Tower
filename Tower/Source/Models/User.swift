import Foundation

public struct User: Equatable {
    public let id: Identifier<Self>
    public var username: String
    
    public init(username: String) {
        self.id = .init()
        self.username = username
    }
}

extension User {
    static let sender: Self = .init(username: "j4cksparr0w")
    static let receiver: Self = .init(username: "windycitymike")
}
