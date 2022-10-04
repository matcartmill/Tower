import Foundation

public struct LoggedInState: Equatable {
    public var conversationsState: ConversationsState
    public var trackingState: TrackingState
    public var notificationsState: NotificationsState
}
