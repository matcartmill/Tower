import ComposableArchitecture
import DomainKit
import Foundation

public typealias AppStore = Store<AppState, AppAction>
public typealias AppViewStore = ViewStore<AppState, AppAction>
public typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>

public let appReducer = AppReducer.combine(
    authReducer.optional().pullback(
        state: \.authState,
        action: /AppAction.auth,
        environment: { $0.authEnvironment }
    ),
    conversationsReducer.optional().pullback(
        state: \.conversationsState,
        action: /AppAction.conversations,
        environment: { $0.conversationsEnvironment }
    ),
    journalReducer.optional().pullback(
        state: \.journalState,
        action: /AppAction.journal,
        environment: { $0.journalEnvironment }
    ),
    .init { state, action, env in
        switch action {
        case .viewShown:
            return .task {
                try! await DispatchQueue.main.sleep(for: 1)
                return .showAuth
            }
            
        case .showAuth:
            state.authState = .init()
            return .none
            
        case .showLoggedInExperience(let user):
            state.conversationsState = .init(user: user)
            state.journalState = .init()
            return .none
            
        // Bridge - Auth
            
        case .auth(.authenticationResponse(.success(let session))):
            state.authRequired = false
            return .init(value: .showLoggedInExperience(session.user))
            
        case .auth:
            return .none
            
        // Bridge - Home
            
        case .conversations:
            return .none
            
        // Bridge - Dashboard
            
        case .journal:
            return .none
        }
    }
)
