import ComposableArchitecture
import Foundation

public typealias AuthStore = Store<AuthState, AuthAction>
public typealias AuthViewStore = ViewStore<AuthState, AuthAction>
public typealias AuthReducer = Reducer<AuthState, AuthAction, AuthEnvironment>

public let authReducer = AuthReducer.init { state, action, env in
    switch action {
    case .showAuthError:
        return .none
        
    case .failed(let errorMessage):
        state.isAuthenticating = false
        state.errorMessage = errorMessage
        return .none
        
    case .authenticate:
        state.isAuthenticating = true
        return .task {
            try! await DispatchQueue.main.sleep(for: 1)
            return .succeeded
        }
        
    case .succeeded:
        state.user = Participant.receiver
        state.isAuthenticating = false
        return .none
    }
}
