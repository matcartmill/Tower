import Foundation

public struct LoggedInEnvironment {
    public let conversationsEnvironment: ConversationsEnvironment
    public let trackingEnvironment: TrackingEnvironment
    public let notificationsEnvironment: NotificationsEnvironment
    
    public init(
        conversationsEnvironment: ConversationsEnvironment,
        trackingEnvironment: TrackingEnvironment,
        notificationsEnvironment: NotificationsEnvironment
    ) {
        self.conversationsEnvironment = conversationsEnvironment
        self.trackingEnvironment = trackingEnvironment
        self.notificationsEnvironment = notificationsEnvironment
    }
}
