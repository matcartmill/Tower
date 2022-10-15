import ComposableArchitecture
import Identifier
import Models

public struct ConversationDetail: ReducerProtocol {
    public struct State: Equatable, Identifiable {
        public var id: Identifier<Conversation> { conversation.id }
        public var newMessage: String
        public var conversation: Conversation
        public var isMoreMenuOpen: Bool
        public var user: User
        
        public init(newMessage: String = "", conversation: Conversation, isMoreMenuOpen: Bool = false, user: User) {
            self.newMessage = newMessage
            self.conversation = conversation
            self.isMoreMenuOpen = isMoreMenuOpen
            self.user = user
        }
    }
    
    public enum Action {
        case dismissMoreMenu
        case leave(Conversation.ID)
        case sendMessage
        case showMoreMenu
        case textFieldChanged(String)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
    }
}
