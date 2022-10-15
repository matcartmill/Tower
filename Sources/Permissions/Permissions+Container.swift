public final class Permissions {
    public let notifications: Permission<Notifications>
    public let photos: Permission<Photos>
    
    public init(
        notifications: Permission<Notifications>,
        photos: Permission<Photos>
    ) {
        self.notifications = notifications
        self.photos = photos
    }
}
