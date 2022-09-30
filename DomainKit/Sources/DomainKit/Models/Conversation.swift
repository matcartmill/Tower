import Foundation
import IdentifiedCollections
import Toolbox

public struct Conversation: Identifiable, Equatable {
    public let id: Identifier<Self>
    public var participants: [User]
    public var messages: IdentifiedArrayOf<Message>
    
    public init(participants: [User], messages: IdentifiedArrayOf<Message>) {
        self.id = .init()
        self.participants = participants
        self.messages = messages
    }
}
