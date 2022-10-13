import ComposableArchitecture
import DomainKit
import Foundation

struct Root: ReducerProtocol {
    enum State: Equatable {
        case loading(AppLoading.State)
        case loggedIn(LoggedIn.State)
        case loggedOut(Auth.State)
        case onboarding(Onboarding.State)
    }
    
    enum Action {
        // Experience
        case showAuth
        case showLoggedInExperience(User)
        case showOnboardingExperience(User)
        
        // Bridges
        case auth(Auth.Action)
        case loggedIn(LoggedIn.Action)
        case onboarding(Onboarding.Action)
        case loading(AppLoading.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .showAuth:
                state = .loggedOut(.init())
                return .none
                
            case .showLoggedInExperience(let user):
                state = .loggedIn(.init(
                    conversations: .init(user: user),
                    tracking: .init(),
                    notifications: .init()
                ))
                return .none
                
            case .showOnboardingExperience(let user):
                state = .onboarding(.username(.init()))
                return .none
                
            // Bridge - Auth
                
            case .auth(.authenticationResponse(.success(let session))):
                return .init(value: .showOnboardingExperience(session.user))
                
            case .auth:
                return .none
                
            // Bridge - Logged In
                
            case .loggedIn:
                return .none
                
            // Bridge - Onboarding
                
            case .onboarding(.complete):
                return .init(value: .showLoggedInExperience(.sender))
                
            case .onboarding:
                return .none
                
            // Bridge - Loading
                
            case .loading(.loaded):
                return .init(value: .showAuth)
                
            case .loading:
                return .none
            }
        }
        .ifCaseLet(/State.loggedIn, action: /Action.loggedIn) {
            LoggedIn()
        }
        .ifCaseLet(/State.loggedOut, action: /Action.auth) {
            Auth()
                .dependency(\.identityProvider, MockIdentityProvider())
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            AppLoading()
        }
    }
}
