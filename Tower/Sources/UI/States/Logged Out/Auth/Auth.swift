import Combine
import ComposableArchitecture
import DomainKit
import Foundation

public struct Auth: ReducerProtocol {
    public struct State: Equatable {
        var errorMessage: String?
        var isAuthenticating = false
        var user: User?
    }
    
    public enum Action {
        case showAuthError
        case authenticate
        case authenticationResponse(TaskResult<Session>)
    }
    
    @Dependency(\.identityProvider) private var identityProvider
    @Dependency(\.sessionGateway) private var sessionGateway
    @Dependency(\.sessionStore) private var sessionStore
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .showAuthError:
                return .none
                
            case .authenticate:
                state.isAuthenticating = true
                
                return .task {
                    await .authenticationResponse(TaskResult {
                        let identity = try await identityProvider.identify()
                        let session = try await sessionGateway.exchange(identity)
                        return session
                    })
                }
                .animation()
                
            case .authenticationResponse(.success(let session)):
                sessionStore.update(session)
                state.user = session.user
                state.isAuthenticating = false
                return .none
                
            case .authenticationResponse(.failure(let error)):
                state.isAuthenticating = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
}
