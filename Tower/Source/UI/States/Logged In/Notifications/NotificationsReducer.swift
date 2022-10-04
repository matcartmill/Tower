import ComposableArchitecture
import Foundation

public typealias NotificationsStore = Store<NotificationsState, NotificationsAction>
public typealias NotificationsViewStore = ViewStore<NotificationsState, NotificationsAction>
public typealias NotificationsReducer = Reducer<NotificationsState, NotificationsAction, NotificationsEnvironment>

public let notificationsReducer = NotificationsReducer { state, action, env in
    return .none
}
