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
        case openWebSocket
        case closeWebSocket
        case handleGatewayAction(IncomingRequestsGateway.Action)
        case accept(IncomingConversationRequest.ID)
        case decline(IncomingConversationRequest.ID)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.incomingRequestsGateway) private var gateway
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadRequests:
                guard let accessToken = sessionStore.session?.accessToken else { return .none }
                
                return .task {
                    do {
                        let requests = try await apiClient.incomingConversationRequests(accessToken)
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
                
            case .openWebSocket:
                return .run { subscriber in
                    for await action in try gateway.open() {
                        await subscriber.send(.handleGatewayAction(action))
                    }
                }
                
            case .closeWebSocket:
                gateway.close()
                return .none
                
            case .handleGatewayAction(let action):
                switch action {
                case .addRequest(let request):
                    state.requests.append(request)
                }
                
                return .none
                
            case .accept(let id):
                return .none
                
            case .decline(let id):
                return .none
            }
        }
    }
}

