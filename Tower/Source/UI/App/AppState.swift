public struct AppState: Equatable {
    public var authRequired = true
    
    public var authState: AuthState?
    public var conversationsState: ConversationsState?
    public var journalState: JournalState?
}
