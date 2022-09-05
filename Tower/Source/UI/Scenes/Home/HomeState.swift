import IdentifiedCollections

public struct HomeState: Equatable {
    public var conversations: IdentifiedArrayOf<ConversationState> = []
    public var user: Participant
    public var accountState: AccountState?
    public var newConversation: ComposeState?
    public var selectedConversation: ConversationState?
}
