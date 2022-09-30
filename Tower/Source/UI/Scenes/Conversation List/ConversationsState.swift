import DomainKit
import IdentifiedCollections

public struct ConversationsState: Equatable {
    public var conversations: IdentifiedArrayOf<ConversationState> = []
    public var user: User
    public var accountState: AccountState?
    public var newConversation: ComposeState?
    public var selectedConversation: ConversationState?
}
