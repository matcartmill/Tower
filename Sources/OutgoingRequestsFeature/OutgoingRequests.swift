import APIClient
import ComposableArchitecture
import Models
import Session

public struct OutgoingRequests: ReducerProtocol {
    public struct State: Equatable {
        public var requests: IdentifiedArrayOf<OutgoingConversationRequest> = []
        
        public init() { }
    }
    
    public enum Action {
        case loadRequests
        case loadFailed(Error)
        case requestsLoaded([OutgoingConversationRequest])
        case cancelOutgoing
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadRequests:
                guard let jwt = sessionStore.session?.jwt else { return .none }
                
                return apiClient.outgoingConversationRequests(jwt)
                    .map {
                        switch $0 {
                        case .success(let outgoing):
                            return .requestsLoaded(outgoing)
                            
                        case .failure(let error):
                            return .loadFailed(error)
                        }
                    }
                
            case .loadFailed(let error):
                print(error.localizedDescription)
                return .none
                
            case .requestsLoaded(let requests):
                state.requests = .init(uniqueElements: requests)
                return .none
                
            case .cancelOutgoing:
                return .none
            }
        }
    }
}
