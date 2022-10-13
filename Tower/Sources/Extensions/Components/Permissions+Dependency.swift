import ComposableArchitecture
import Toolbox
import UserNotifications

extension Permissions: DependencyKey {
    public static var liveValue: Permissions {
        .init(notifications: .notifications, photos: .photos)
    }
}

extension DependencyValues {
  var permissions: Permissions {
    get { self[Permissions.self] }
    set { self[Permissions.self] = newValue }
  }
}
