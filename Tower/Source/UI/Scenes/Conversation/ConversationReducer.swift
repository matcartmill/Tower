import ComposableArchitecture

public typealias ConversationStore = Store<ConversationState, ConversationAction>
public typealias ConversationViewStore = ViewStore<ConversationState, ConversationAction>
public typealias ConversationReducer = Reducer<ConversationState, ConversationAction, ConversationEnvironment>

public let conversationReducer = ConversationReducer.init { state, action, env in
    switch action {
    case .sendMessage:
        state.conversation.messages.append(.init(content: state.newMessage, sender: Participant.sender.id))
        state.newMessage = ""
        
        return .none
        
    case .textFieldChanged(let messageContent):
        state.newMessage = messageContent
        
        return .none
    }
}
