import Foundation

public struct CreateConversationRequest: Encodable {
    public let category: Conversation.Category
    public let content: String
    
    public init(category: Conversation.Category, content: String) {
        self.category = category
        self.content = content
    }
}

extension CreateConversationRequest {
    public init(_ newConversation: NewConversation) {
        self.init(
            category: newConversation.category,
            content: newConversation.content
        )
    }
}
