import APIClient
import ComposableArchitecture
import Models
import Session

public struct IncomingRequests: ReducerProtocol {
    public struct State: Equatable {
        public var requests: IdentifiedArrayOf<IncomingConversationRequest> = []
        
        public init() { }
    }
    
    public enum Action {
        case loadRequests
        case loadFailed(Error)
        case requestsLoaded([IncomingConversationRequest])
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadRequests:
                guard let jwt = sessionStore.session?.jwt else { return .none }
                
                return apiClient.incomingConversationRequests(jwt)
                    .map {
                        switch $0 {
                        case .success(let incoming):
                            return .requestsLoaded(incoming)
                            
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
            }
        }
    }
}

