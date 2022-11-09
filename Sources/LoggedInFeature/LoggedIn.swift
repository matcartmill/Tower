import APIClient
import ComposableArchitecture
import ConversationsFeature
import Foundation
import NotificationsFeature
import TrackingFeature

public struct LoggedIn: ReducerProtocol {
    public struct State: Equatable {
        var conversations: Conversations.State
        var tracking: Tracking.State
        var notifications: NotificationsList.State
        
        public init(conversations: Conversations.State, tracking: Tracking.State, notifications: NotificationsList.State) {
            self.conversations = conversations
            self.tracking = tracking
            self.notifications = notifications
        }
    }
    
    public enum Action {
        case conversations(Conversations.Action)
        case tracking(Tracking.Action)
        case notifications(NotificationsList.Action)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.conversations, action: /Action.conversations) {
            Conversations()
//                .dependency(\.apiClient, .mock)
        }
        Scope(state: \.tracking, action: /Action.tracking) {
            Tracking()
                .dependency(\.apiClient, .mock)
        }
        Scope(state: \.notifications, action: /Action.notifications) {
            NotificationsList()
        }
    }
}
