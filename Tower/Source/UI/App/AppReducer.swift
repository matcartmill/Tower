import ComposableArchitecture
import DomainKit
import Foundation

public typealias AppStore = Store<AppState, AppAction>
public typealias AppViewStore = ViewStore<AppState, AppAction>
public typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>

public let appReducer = AppReducer.combine(
    authReducer.pullback(
        state: /AppState.loggedOut,
        action: /AppAction.auth,
        environment: { $0.authEnvironment }
    ),
    loggedInReducer.pullback(
        state: /AppState.loggedIn,
        action: /AppAction.loggedIn,
        environment: { _ in .init() }
    ),
    onboardingReducer.pullback(
        state: /AppState.onboarding,
        action: /AppAction.onboarding,
        environment: { _ in .init() }
    ),
    appLoadingReducer.pullback(
        state: /AppState.loading,
        action: /AppAction.loading,
        environment: { _ in .init() }
    ),
    .init { state, action, env in
        switch action {            
        case .showAuth:
            state = .loggedOut(.init())
            return .none
            
        case .showLoggedInExperience(let user):
            state = .loggedIn(.init(
                conversationsState: .init(user: user),
                trackingState: .init(),
                notificationsState: .init()
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
)
