import Foundation
import Identifier

public struct Conversation: Codable, Identifiable, Equatable {
    public let id: Identifier<Self>
    public var authorId: Identifier<User>
    public var partnerId: Identifier<User>?
    public var messages: [Message]
    
    public init(
        id: Identifier<Self>,
        authorId: Identifier<User>,
        partnerId: Identifier<User>?,
        messages: [Message]
    ) {
        self.id = id
        self.authorId = authorId
        self.partnerId = partnerId
        self.messages = messages
    }
}
