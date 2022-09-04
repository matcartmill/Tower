public enum HomeAction: Equatable {
    // Compose
    case openComposer
    
    // Details
    case openConversation(id: Conversation.ID)
    case dismissConversation
    case item(id: Conversation.ID, action: ConversationAction)
    
    // Bridges
    case conversation(ConversationAction)
    case compose(ComposeAction)
}
