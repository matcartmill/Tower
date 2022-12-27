import AuthFeature
import ComposableArchitecture
import Foundation
import Session

public struct SignIn: ReducerProtocol {
    public struct State: Equatable {
        fileprivate var authState: Auth.State = .init()
        
        var errorMessage: String?
        var isAuthenticating = false
        
        public init(errorMessage: String? = nil, isAuthenticating: Bool = false) {
            self.errorMessage = errorMessage
            self.isAuthenticating = isAuthenticating
        }
    }
    
    public enum Action {
        case signInTapped
        case signInResult(TaskResult<Session>)
        case authErrorDismissed
        
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
            case .signInTapped:
                return .task { .auth(.authenticate) }
                
            case .signInResult:
                return .none
                
            case .authErrorDismissed:
                return .none
                
            case .auth(.authenticationResponse(let response)):
                return .task { .signInResult(response) }
                
            case .auth:
                return .none
            }
        }
    }
}
