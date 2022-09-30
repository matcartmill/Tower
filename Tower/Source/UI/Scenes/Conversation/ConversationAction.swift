import DomainKit

public enum ConversationAction: Equatable {
    case dismissMoreMenu
    case leave(Conversation.ID)
    case sendMessage
    case showMoreMenu
    case textFieldChanged(String)
}
