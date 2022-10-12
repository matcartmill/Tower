import Toolbox

class Permissions {
    let notifications: Permission<Notifications>
    let photos: Permission<Photos>
    
    init(
        notifications: Permission<Notifications>,
        photos: Permission<Photos>
    ) {
        self.notifications = notifications
        self.photos = photos
    }
}
