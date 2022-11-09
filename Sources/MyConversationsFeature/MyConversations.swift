import APIClient
import ComposableArchitecture
import ConversationFeature
import Foundation
import Models
import Session

public struct MyConversations: ReducerProtocol {
    public struct State: Equatable {
        public let user: User
        public var conversations: IdentifiedArrayOf<ConversationDetail.State> = []
        
        public init(user: User) {
            self.user = user
        }
    }
    
    public enum Action {
        case loadConversations
        case conversationsLoaded([Conversation])
        case selectedConversation(ConversationDetail.State)
        case item(id: UUID, action: ConversationDetail.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadConversations:
                guard let jwt = sessionStore.session?.jwt else { return .none }
                
                var myConversations = [Conversation]()
                
                return apiClient.myConversations(jwt).map { result in
                    switch result {
                    case .success(let conversations):
                        myConversations = conversations.map { .init(
                            id: .init($0.id.uuidString),
                            authorId: .init($0.authorId.uuidString),
                            partnerId: nil,
                            messages: $0.messages)
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    return .conversationsLoaded(myConversations)
                }
                
            case .conversationsLoaded(let conversations):
                let conversationStates = conversations.map {
                    ConversationDetail.State.init(conversation: $0, user: state.user)
                }
                
                state.conversations = .init(uniqueElements: conversationStates)
                
                return .none
                
            case .selectedConversation:
                return .none
                
            case .item:
                return .none
            }
        }
//        .forEach(\.conversations, action: /Action.item(id:action:)) {
//            ConversationDetail()
//        }
    }
}
