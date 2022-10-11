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
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .showAuthError:
                return .none
                
            case .authenticate:
                state.isAuthenticating = true
                
                return .task {
                    await .authenticationResponse(TaskResult {
                        //let identity = try await env.identityProvider.identify()
                        //let session = try await env.sessionGateway.exchange(identity)
                        return Session(token: .init("abc"), user: .sender)
                    })
                }
                .animation()
                
            case .authenticationResponse(.success(let session)):
                // env.sessionStore.update(session)
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
