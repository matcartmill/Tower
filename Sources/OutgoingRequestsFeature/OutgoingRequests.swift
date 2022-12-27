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
        case addRequest(OutgoingConversationRequest)
        case cancel(OutgoingConversationRequest.ID)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadRequests:
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                
                return .task {
                    do {
                        let requests = try await apiClient.outgoingConversationRequests(accessToken)
                        return .requestsLoaded(requests)
                    } catch let error {
                        return .loadFailed(error)
                    }
                }
                
            case .loadFailed(let error):
                print(error.localizedDescription)
                return .none
                
            case .requestsLoaded(let requests):
                state.requests = .init(uniqueElements: requests)
                return .none
                
            case .addRequest(let request):
                state.requests.append(request)
                return .none
                
            case .cancel(let id):
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                
                state.requests.remove(id: id)
                
                return .fireAndForget {
                    try await apiClient.cancelOutgoingRequest(accessToken, id)
                }
            }
        }
    }
}
