import ComposableArchitecture
import Foundation

public struct LoggedIn: ReducerProtocol {
    public struct State: Equatable {
        var conversations: Conversations.State
        var tracking: Tracking.State
        var notifications: Notifications.State
    }
    
    public enum Action {
        case conversations(Conversations.Action)
        case tracking(Tracking.Action)
        case notifications(Notifications.Action)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.conversations, action: /Action.conversations) {
            Conversations()
        }
        Scope(state: \.tracking, action: /Action.tracking) {
            Tracking()
        }
        Scope(state: \.notifications, action: /Action.notifications) {
            Notifications()
        }
    }
}
