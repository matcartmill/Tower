import Foundation
import IdentifiedCollections

public struct Conversation: Identifiable, Equatable {
    public let id: Identifier<Self>
    public var participants: [Participant]
    public var messages: IdentifiedArrayOf<Message>
    
    public init(participants: [Participant], messages: IdentifiedArrayOf<Message>) {
        self.id = .init()
        self.participants = participants
        self.messages = messages
    }
}
