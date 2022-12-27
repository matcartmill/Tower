import APIClient
import ComposableArchitecture
import ConversationFeature
import Models
import Session

public struct OpenConversations: ReducerProtocol {
    public struct State: Equatable {
        fileprivate var page = 1
        fileprivate var total = Int.max
        
        public var conversations: IdentifiedArrayOf<ConversationSummary>
        public var canLoadMoreConversations = true
        
        public init(conversations: IdentifiedArrayOf<ConversationSummary> = []) {
            self.conversations = conversations
        }
    }
    
    public enum Action {
        case loadConversations
        case openWebSocket
        case closeWebSocket
        case conversationsLoaded(PagedResponse<[ConversationSummary]>)
        case conversationsFailedToLoad(Error)
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
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                           
                let pageInfo = PageInfo(page: state.page, per: 5)
                
                return .task {
                    do {
                        let response = try await apiClient.openConversations(accessToken, pageInfo)
                        return .conversationsLoaded(response)
                    } catch let error {
                        return .conversationsFailedToLoad(error)
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
                
            case .closeWebSocket:
                gateway.close()
                return .none
                
            case .conversationsLoaded(let response):
                state.total = response.metadata.total
                state.conversations.append(contentsOf: response.items)
                
                let conversationCount = state.conversations.count
                
                state.canLoadMoreConversations = conversationCount < state.total
                
                if conversationCount <= state.total {
                    state.page += 1
                }
                
                return .none
                
            case .conversationsFailedToLoad(let error):
                print(error.localizedDescription)
                return .none
                
            case .removeExistingSummary(let id):
                state.conversations.remove(id: id)
                return .none
            }
        }
    }
}
