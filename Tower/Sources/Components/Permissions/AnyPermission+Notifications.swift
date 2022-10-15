import Foundation
import UserNotifications

public struct Notifications: PermissionType { }

extension AnyPermission {
    public static var notifications: Permission<Notifications> {
        return notifications([.alert, .badge, .sound])
    }

    public static func notifications(_ options: UNAuthorizationOptions) -> Permission<Notifications> {
        return .init(
            name: "Notifications",
            status: { PermissionState(from: UNUserNotificationCenter.current().getNotificationSettings().authorizationStatus) },
            requestAccess: { complete in
                UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
                    DispatchQueue.main.async {
                        complete(AnyPermission.notifications(options).status())
                    }
                }
            }
        )
    }
}

private extension PermissionState {
    init(from status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .unknown
        case .authorized: self = .authorized
        case .denied: self = .denied
        default: self = .denied
        }
    }
}

private extension UNUserNotificationCenter {
    func getNotificationSettings() -> UNNotificationSettings {
        var result: UNNotificationSettings!
        let group = DispatchGroup()
        group.enter()
        getNotificationSettings { settings in
            result = settings
            group.leave()
        }
        group.wait()
        return result
    }
}
