import Foundation

public struct Conversation: Codable, Identifiable, Equatable {
    public let id: Identifier<Self>
    public var author: User
    public var participant: User?
    public var messages: [Message]
    
    public init(
        author: User,
        participant: User?,
        messages: [Message]
    ) {
        self.id = .init()
        self.author = author
        self.participant = participant
        self.messages = messages
    }
}
