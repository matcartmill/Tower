import Foundation

public struct Participant: Equatable {
    public let id: Identifier<Self>
    public var profileImageUrl: URL
    
    public init(profileImageUrl: URL) {
        self.id = .init()
        self.profileImageUrl = profileImageUrl
    }
}

extension Participant {
    static let sender: Participant = .init(profileImageUrl: URL(string: "https://faces-img.xcdn.link/image-lorem-face-5370.jpg")!)
    static let receiver: Participant = .init(profileImageUrl: URL(string: "https://faces-img.xcdn.link/image-lorem-face-2914.jpg")!)
}
