import ComposableArchitecture

public typealias ConversationStore = Store<ConversationState, ConversationAction>
public typealias ConversationViewStore = ViewStore<ConversationState, ConversationAction>
public typealias ConversationReducer = Reducer<ConversationState, ConversationAction, ConversationEnvironment>

public let conversationReducer = ConversationReducer.init { state, action, env in
    switch action {
    case .dismissMoreMenu:
        state.isMoreMenuOpen = false
        
        return .none
        
    case .leave:
        return .none
        
    case .sendMessage:
        state.conversation.messages.append(
            .init(content: state.newMessage, sender: state.user)
        )
        state.newMessage = ""
        
        return .none
        
    case .showMoreMenu:
        state.isMoreMenuOpen = true
        
        return .none
        
    case .textFieldChanged(let messageContent):
        state.newMessage = messageContent
        
        return .none
    }
}
