import ComposableArchitecture
import DomainKit

public struct Compose: ReducerProtocol {
    public struct State: Equatable {
        public var conversation: Conversation
        public var message = ""
        public var user: User
    }
    
    public enum Action {
        case textFieldChanged(String)
        case start
        case cancel
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .textFieldChanged(let messageContent):
                state.message = messageContent
                
                return .none
                
            case .start:
                state.conversation.messages.append(
                    .init(content: state.message, sender: state.user)
                )
                state.conversation.participant = state.user
                
                return .none
                
            case .cancel:
                return .none
            }
        }
    }
}
