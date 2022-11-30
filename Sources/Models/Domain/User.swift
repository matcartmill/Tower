import Foundation
import Identifier

public struct User: Codable, Equatable, Identifiable {
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
        username: "daydreamer1982",
        avatarUrl: .init(string: "https://faces-img.xcdn.link/image-lorem-face-6749.jpg")!
    )
    public static let mike: Self = .init(
        username: "windycitymike",
        avatarUrl: .init(string: "https://faces-img.xcdn.link/image-lorem-face-1156.jpg")!
    )
    public static let lynn: Self = .init(
        username: "offtothestars",
        avatarUrl: .init(string: "https://faces-img.xcdn.link/image-lorem-face-6344.jpg")!
    )
}
