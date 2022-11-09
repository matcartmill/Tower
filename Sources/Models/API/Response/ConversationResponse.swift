import Foundation

public struct TransmittedConversation: Decodable {
    public let id: UUID
    public let authorId: UUID
    public let messages: [Message]
    public let createdAt: Date
    
    public init(id: UUID, authorId: UUID, messages: [Message], createdAt: Date) {
        self.id = id
        self.authorId = authorId
        self.messages = messages
        self.createdAt = createdAt
    }
}
