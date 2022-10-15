import ComposableArchitecture
import Foundation

public struct Auth: ReducerProtocol {
    public struct State: Equatable {
        var errorMessage: String?
        var isAuthenticating = false
    }
    
    public enum Action {
        case showAuthError
        case authenticate
        case authenticationResponse(TaskResult<Session>)
        
        case fetchIdentity
        case exchangeIdentity(Identity)
        case fetchUser(JWT)
    }
    
    @Dependency(\.identityProvider) private var identityProvider
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .showAuthError:
                return .none
                
            case .authenticate:
                state.isAuthenticating = true
                
                return .task { .fetchIdentity }
                
            case .authenticationResponse(.success(let session)):
                sessionStore.update(session)
                state.isAuthenticating = false
                return .none
                
            case .authenticationResponse(.failure(let error)):
                state.isAuthenticating = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .fetchIdentity:
                return .task {
                    let identity = try await identityProvider.identify()
                    return .exchangeIdentity(identity)
                }
                
            case .exchangeIdentity(let identity):
                return apiClient.exchange(identity)
                    .map { result in
                        switch result {
                        case .success(let jwt):
                            return .fetchUser(jwt)
                            
                        case .failure(let error):
                            return .authenticationResponse(.failure(error))
                        }
                    }
                
            case .fetchUser(let jwt):
                return apiClient.me(jwt)
                    .map { result in
                        switch result {
                        case .success(let user):
                            let session = Session(jwt: jwt, user: user)
                            return .authenticationResponse(.success(session))
                            
                        case .failure(let error):
                            return .authenticationResponse(.failure(error))
                        }
                    }
                    .animation()
            }
        }
    }
}
