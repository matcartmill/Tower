import APIClient
import ComposableArchitecture
import ConversationFeature
import Models
import Session

public struct OpenConversations: ReducerProtocol {
    public struct State: Equatable {
        public var conversations: IdentifiedArrayOf<ConversationSummary>
        
        public init(conversations: IdentifiedArrayOf<ConversationSummary> = []) {
            self.conversations = conversations
        }
    }
    
    public enum Action {
        case loadConversations
        case openWebSocket
        case conversationsLoaded([ConversationSummary])
        case removeExistingSummary(Conversation.ID)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.openConversationsGateway) var gateway
    @Dependency(\.sessionStore) var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadConversations:
                guard let jwt = sessionStore.session?.jwt else { return .none }
                
                var openConversations: [ConversationSummary] = []
                
                return apiClient.openConversations(jwt).map { result in
                    switch result {
                    case .success(let conversations):
                        openConversations = conversations.items
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    return .conversationsLoaded(openConversations)
                }
                
            case .openWebSocket:
                return .run { subscriber in
                    for await action in try gateway.open() {
                        switch action {
                        case .removeConversation(let id):
                            await subscriber.send(.removeExistingSummary(id))
                        }
                    }
                }
                
            case .conversationsLoaded(let conversations):
                state.conversations.append(contentsOf: conversations)
                return .none
                
            case .removeExistingSummary(let id):
                state.conversations.remove(id: id)
                return .none
            }
        }
    }
}
