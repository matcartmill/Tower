import APIClient
import ComposableArchitecture
import Foundation
import Models
import Session

public struct MyConversations: ReducerProtocol {
    public struct State: Equatable {
        public var conversations: IdentifiedArrayOf<Conversation> = []
        
        public init() { }
    }
    
    public enum Action {
        case loadConversations
        case conversationsLoaded([Conversation])
        case openWebSocket
        case closeWebSocket
        case handleSocketAction(MyConversationsGateway.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.myConversationsGateway) private var gateway
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadConversations:
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                                
                return .task {
                    do {
                        let conversations = try await apiClient.myConversations(accessToken).map {
                            Conversation(
                                id: .init($0.id.uuidString),
                                author: $0.author,
                                partner: $0.participant,
                                messages: $0.messages,
                                createdAt: $0.createdAt,
                                updatedAt: $0.updatedAt
                            )
                        }
                            .sorted(by: { $0.updatedAt < $1.updatedAt })
                        
                        return .conversationsLoaded(conversations)
                    } catch let error {
                        print(error.localizedDescription)
                        return .conversationsLoaded([])
                    }
                }
                
            case .conversationsLoaded(let conversations):
                state.conversations = .init(uniqueElements: conversations)
                return .none
                
            case .openWebSocket:
                return .run { subscriber in
                    for await action in try gateway.open() {
                        await subscriber.send(.handleSocketAction(action))
                    }
                }
                
            case .closeWebSocket:
                gateway.close()
                return .none
                
            case .handleSocketAction(let action):
                switch action {
                case .addConversation(let conversation):
                    state.conversations.insert(conversation, at: 0)
                }
                return .none
            }
        }
    }
}
