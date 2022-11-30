import Foundation

public struct TransmittedConversation: Equatable, Decodable {
    public let id: UUID
    public let author: BasicUserDetails
    public let participant: BasicUserDetails?
    public let messages: [Message]
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: UUID,
        author: BasicUserDetails,
        participant: BasicUserDetails?,
        messages: [Message],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.author = author
        self.participant = participant
        self.messages = messages
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
