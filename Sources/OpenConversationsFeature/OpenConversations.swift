import APIClient
import ComposableArchitecture
import ConversationFeature
import Models
import Session

public struct OpenConversations: ReducerProtocol {
    public struct State: Equatable {
        fileprivate var page = 1
        fileprivate var per = 5
        
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
                           
                let pageInfo = PageInfo(page: state.page, per: state.per)
                
                return .task {
                    do {
                        let conversations = try await apiClient.openConversations(jwt, pageInfo)
                        return .conversationsLoaded(conversations.items)
                    } catch let error {
                        print(error.localizedDescription)
                        return .conversationsLoaded([])
                    }
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
