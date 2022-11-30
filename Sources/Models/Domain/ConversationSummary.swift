import Foundation
import Identifier

public struct ConversationSummary: Equatable, Decodable, Identifiable {
    public let id: Conversation.ID
    public let summary: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: Conversation.ID,
        summary: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.summary = summary
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
