public struct NewConversation: Equatable {
    public var category: Conversation.Category
    public var content: String
    
    public init(category: Conversation.Category, content: String) {
        self.category = category
        self.content = content
    }
}
