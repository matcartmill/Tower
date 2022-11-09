import Foundation
import Identifier

public struct User: Codable, Equatable {
    public let id: Identifier<Self>
    public var username: String?
    public var avatarUrl: URL?
    
    public init(username: String?, avatarUrl: URL?) {
        self.id = .init()
        self.username = username
        self.avatarUrl = avatarUrl
    }
}

extension User {
    public static let sender: Self = .init(
        username: "j4cksparr0w",
        avatarUrl: nil
    )
    public static let receiver: Self = .init(
        username: "windycitymike",
        avatarUrl: nil
    )
}
