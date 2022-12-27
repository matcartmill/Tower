import APIClient
import ComposableArchitecture
import Foundation
import Identity
import JWT
import Models
import Session
import Storage

public struct Auth: ReducerProtocol {
    public enum AuthError: Error {
        case noExistingRefreshToken
    }
    
    public struct State: Equatable {
        var isAuthenticating = false
        
        public init(isAuthentication: Bool = false) {
            self.isAuthenticating = isAuthentication
        }
    }
    
    public enum Action {
        case authenticate
        case authenticationResponse(TaskResult<Session>)
        
        case fetchIdentity
        case exchangeIdentity(Identity)
        
        case refresh
        
        case extractTokens(AuthenticationResponse)
        case fetchUser(AccessToken)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.identityProvider) private var identityProvider
    @Dependency(\.keychain) private var keychain
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .authenticate:
                state.isAuthenticating = true
                
                return .task { .fetchIdentity }
                
            case .authenticationResponse(.success(let session)):
                sessionStore.update(session)
                state.isAuthenticating = false
                return .none
                
            case .authenticationResponse(.failure):
                state.isAuthenticating = false
                return .none
                
            case .fetchIdentity:
                return .task {
                    let identity = try await identityProvider.identify()
                    return .exchangeIdentity(identity)
                }
                
            case .exchangeIdentity(let identity):
                return .task {
                    do {
                        let response = try await apiClient.exchange(identity)
                        return .extractTokens(response)
                    } catch let error {
                        return .authenticationResponse(.failure(error))
                    }
                }
                
            case .refresh:
                guard let refreshToken = keychain.value(for: .refreshToken) else {
                    return .task { .authenticationResponse(.failure(AuthError.noExistingRefreshToken)) }
                }
                
                return .task {
                    do {
                        let response = try await apiClient.refresh(.init(jwt: refreshToken))
                        return .extractTokens(response)
                    } catch let error {
                        return .authenticationResponse(.failure(error))
                    }
                }
                
            case .extractTokens(let response):
                let accessToken = AccessToken(response.accessToken)
                let refreshToken = RefreshToken(response.refreshToken)
                
                keychain.update(.refreshToken, to: refreshToken.description)
                
                return .task { .fetchUser(accessToken) }
                
            case .fetchUser(let accessToken):
                return .task {
                    do {
                        let user = try await apiClient.me(accessToken)
                        let session = Session(accessToken: accessToken, user: user)
                        return .authenticationResponse(.success(session))
                    } catch let error {
                        print(error.localizedDescription)
                        return .authenticationResponse(.failure(error))
                    }
                }
            }
        }
    }
}

private extension Setting {
    static var refreshToken: Setting<String> { .init(key: "auth-refresh-token", defaultValue: nil) }
}
