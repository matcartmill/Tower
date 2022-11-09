import APIClient
import ComposableArchitecture
import Foundation
import JWT
import Session

public struct UsernameOnboardingStep: ReducerProtocol {
    public enum Error: Swift.Error {
        case invalidUsername
        case remote(Swift.Error)
        case usernameTaken
    }
    public struct State: Equatable {
        // var error: Error?
        var username: String
        
        public init(username: String = "") {
            self.username = username
        }
    }
    
    public enum Action {
        case error(Swift.Error)
        case next
        case submitUsername
        case textFieldChanged(String)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .error(let error):
                // state.error = .remote
                
                return .none
                
            case .next:
                return .none
                
            case .submitUsername:
                guard
                    !state.username.isEmpty,
                    let session = sessionStore.session
                else { return .none }
                
                var user = session.user
                user.username = state.username
                
                return apiClient.updateMe(session.jwt, user)
                    .map {
                        switch $0 {
                        case .success(let updatedUser):
                            sessionStore.update(.init(jwt: session.jwt, user: updatedUser))
                            return .next
                            
                        case .failure(let error):
                            return .error(error)
                        }
                    }
                
            case .textFieldChanged(let value):
                state.username = value
                return .none
            }
        }
    }
}

