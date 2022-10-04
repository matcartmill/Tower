import DomainKit

public enum ConversationsAction {
    case viewShown
    
    // Account
    case openAccount
    
    // Compose
    case openComposer
    
    // Notifications
    case openNotifications
    
    // Details
    case openConversation(id: Conversation.ID)
    case dismissConversation
    case item(id: Conversation.ID, action: ConversationAction)
    
    // Bridges
    case account(AccountAction)
    case compose(ComposeAction)
    case conversation(ConversationAction)
    case onboarding(ConversationOnboardingAction)
}
