import ComposableArchitecture

public typealias ComposeStore = Store<ComposeState, ComposeAction>
public typealias ComposeViewStore = ViewStore<ComposeState, ComposeAction>
public typealias ComposeReducer = Reducer<ComposeState, ComposeAction, ComposeEnvironment>

public let composeReducer = ComposeReducer.init { state, action, env in
    switch action {
    case .binding:
        return .none
        
    case .viewLoaded:
        state.isComposingFocused = true

        return .none
    case .textFieldChanged(let messageContent):
        state.message = messageContent
        
        return .none
        
    case .start:
        state.isComposingFocused = false
        state.conversation.messages.append(
            .init(content: state.message, sender: Participant.sender.id)
        )
        
        return .none
        
    case .cancel:
        return .none
    }
}