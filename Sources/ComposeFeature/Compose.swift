import ComposableArchitecture
import Models

public struct Compose: ReducerProtocol {
    public struct State: Equatable {
        public var conversation: Conversation
        public var message: String
        public var user: User
        
        public init(conversation: Conversation, message: String = "", user: User) {
            self.conversation = conversation
            self.message = message
            self.user = user
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
                state.message = messageContent
                
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
