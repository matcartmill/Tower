import Foundation

public struct LoggedInEnvironment {
    public let conversationsEnvironment: ConversationsEnvironment
    public let trackingEnvironment: TrackingEnvironment
    public let notificationsEnvironment: NotificationsEnvironment
    
    public init() {
        self.conversationsEnvironment = .init()
        self.trackingEnvironment = .init()
        self.notificationsEnvironment = .init()
    }
}
