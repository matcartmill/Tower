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
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadConversations:
                guard let jwt = sessionStore.session?.jwt else { return .none }
                                
                return .task {
                    do {
                        let conversations = try await apiClient.myConversations(jwt).map {
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
            }
        }
    }
}
