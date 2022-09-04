import IdentifiedCollections

public struct ConversationState: Equatable, Identifiable {
    public var id: Identifier<Conversation> { conversation.id }
    public var newMessage = ""
    public var conversation: Conversation
    
    public init(conversation: Conversation) {
        self.conversation = conversation
    }
}
