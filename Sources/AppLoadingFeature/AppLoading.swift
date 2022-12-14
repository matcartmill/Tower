import AuthFeature
import ComposableArchitecture
import Foundation
import Session

public struct AppLoading: ReducerProtocol {
    public struct State: Equatable {
        fileprivate var authState: Auth.State = .init()
        
        public init() { }
    }
    
    public enum Action {
        case load
        case loaded(TaskResult<Session>)
        
        // Bridges
        
        case auth(Auth.Action)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.authState, action: /Action.auth) {
            Auth()
        }
        
        Reduce { state, action in
            switch action {
            case .load:
                return .task { .auth(.refresh) }
                
            case .loaded:
                return .none
                
            // Bridge - Auth
                
            case .auth(.authenticationResponse(let response)):
                return .task { .loaded(response) }
                
            case .auth:
                return .none
            }
        }
    }
}
