import ComposableArchitecture
import Foundation

public typealias LoggedInStore = Store<LoggedInState, LoggedInAction>
public typealias LoggedInViewStore = ViewStore<LoggedInState, LoggedInAction>
public typealias LoggedInReducer = Reducer<LoggedInState, LoggedInAction, LoggedInEnvironment>

public let loggedInReducer = LoggedInReducer.combine(
    conversationsReducer.pullback(
        state: \.conversationsState,
        action: /LoggedInAction.conversations,
        environment: { _ in .mock }
    ),
    trackingReducer.pullback(
        state: \.trackingState,
        action: /LoggedInAction.tracking,
        environment: { _ in .init() }
    ),
    notificationsReducer.pullback(
        state: \.notificationsState,
        action: /LoggedInAction.notifications,
        environment: { _ in .init() }
    ),
    .init { state, action, env in
        switch action {
        case .conversations:
            return .none
            
        case .tracking:
            return .none
            
        case .notifications:
            return .none
        }
    }
)
