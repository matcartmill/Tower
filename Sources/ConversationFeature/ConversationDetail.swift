import APIClient
import ComposableArchitecture
import Core
import Foundation
import JWT
import Models
import NetworkEnvironment
import Session

public struct ConversationDetail: ReducerProtocol {
    public struct State: Equatable, Identifiable {
        public var id: UUID = .init()
        public var conversation: Conversation
        public var user: User
        public var newMessage = ""
        public var isMoreMenuOpen = false
        
        public init(conversation: Conversation, user: User) {
            self.conversation = conversation
            self.user = user
        }
    }
    
    public enum Action {
        case openWebSocket
        case handleGatewayAction(ConversationGateway.Action)
        case dismissMoreMenu
        case leave(Conversation.ID)
        case sendMessage
        case showMoreMenu
        case textFieldChanged(String)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.sessionStore) var sessionStore
    @Dependency(\.conversationGateway) var gateway
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .openWebSocket:
                let conversationId = state.conversation.id

                return .run { subscriber in
                    for await action in try gateway.open(conversationId) {
                        await subscriber.send(.handleGatewayAction(action))
                    }
                }
                
            case .handleGatewayAction(let action):
                switch action {
                case .addMessage(let message):
                    state.conversation.messages.append(message)
                }
                
                return .none
                
            case .dismissMoreMenu:
                state.isMoreMenuOpen = false
                
                return .none
                
            case .leave:
                return .none
                
            case .sendMessage:
                let id = state.conversation.id
                let message = state.newMessage
                state.newMessage = ""
                
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                
                return .fireAndForget(priority: .userInitiated) {
                    try await apiClient.sendMessage(accessToken, message, id)
                }
                
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
