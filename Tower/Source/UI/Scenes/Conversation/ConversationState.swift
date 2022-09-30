import DomainKit
import IdentifiedCollections
import Toolbox

public struct ConversationState: Equatable, Identifiable {
    public var id: Identifier<Conversation> { conversation.id }
    public var newMessage = ""
    public var conversation: Conversation
    public var isMoreMenuOpen = false
    public var user: User
}
