import Combine
import ComposableArchitecture
import Foundation

public typealias AuthStore = Store<AuthState, AuthAction>
public typealias AuthViewStore = ViewStore<AuthState, AuthAction>
public typealias AuthReducer = Reducer<AuthState, AuthAction, AuthEnvironment>

public let authReducer = AuthReducer.init { state, action, env in
    switch action {
    case .showAuthError:
        return .none
        
    case .authenticate:
        state.isAuthenticating = true
        
        return .task {
            await .authenticationResponse(TaskResult {
                let identity = try await env.identityProvider.identify()
                let session = try await env.sessionGateway.exchange(identity)
                return session
            })
        }
        
    case .authenticationResponse(.success(let session)):
        env.sessionStore.update(session)
        state.user = session.user
        state.isAuthenticating = false
        return .none
        
    case .authenticationResponse(.failure(let error)):
        state.isAuthenticating = false
        state.errorMessage = error.localizedDescription
        return .none
    }
}
