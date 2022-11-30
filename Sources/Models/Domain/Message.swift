import Foundation
import Identifier

public struct Message: Codable, Equatable, Identifiable {
    public let id: Identifier<Self>
    public let authorId: Identifier<User>
    public let conversationId: Identifier<Conversation>
    public let content: String
    public let createdAt: Date?
    
    public init(
        id: Identifier<Self>,
        authorId: Identifier<User>,
        conversationId: Identifier<Conversation>,
        content: String,
        createdAt: Date?
    ) {
        self.id = id
        self.authorId = authorId
        self.conversationId = conversationId
        self.content = content
        self.createdAt = createdAt
    }
}
