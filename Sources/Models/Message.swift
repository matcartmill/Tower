import Foundation
import Identifier

public struct Message: Codable, Equatable, Identifiable {
    public let id: Identifier<Self>
    public let content: String
    public let sender: User
    
    public init(content: String, sender: User) {
        self.id = .init()
        self.content = content
        self.sender = sender
    }
}
