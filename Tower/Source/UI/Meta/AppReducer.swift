import ComposableArchitecture
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
    homeReducer.optional().pullback(
        state: \.homeState,
        action: /AppAction.home,
        environment: { $0.homeEnvironment }
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
            
        case .showHome(let user):
            state.homeState = .init(user: user)
            return .none
            
        // Bridge - Auth
            
        case .auth(.authenticationResponse(.success(let session))):
            return .init(value: .showHome(session.user))
            
        case .auth:
            return .none
            
        // Bridge - Home
            
        case .home:
            return .none
        }
    }
)
