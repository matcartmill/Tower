import DomainKit

public enum AppAction {
    case viewShown

    // Experience
    
    case showAuth
    case showLoggedInExperience(User)
    
    // Bridge - Auth
    
    case auth(AuthAction)
    
    // Bridge - Conversations (List)
    
    case conversations(ConversationsAction)
    
    // Bridge - Journal
    
    case journal(JournalAction)
}
