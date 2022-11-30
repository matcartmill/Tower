import ComposableArchitecture
import Models

public struct Compose: ReducerProtocol {
    public struct State: Equatable {
        public var newConversation: NewConversation
        
        public init(newConversation: NewConversation) {
            self.newConversation = newConversation
        }
    }
    
    public enum Action {
        case textFieldChanged(String)
        case start
        case close
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .textFieldChanged(let messageContent):
                state.newConversation.content = messageContent
                
                return .none
                
            case .start:
               // TODO: Network here
                
                return .none
                
            case .close:
                return .none
            }
        }
    }
}
