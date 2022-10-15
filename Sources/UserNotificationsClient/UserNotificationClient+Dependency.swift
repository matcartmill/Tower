import Combine
import ComposableArchitecture
import UserNotifications
import XCTestDynamicOverlay

extension DependencyValues {
    public var userNotifications: UserNotificationClient {
        get { self[UserNotificationClient.self] }
        set { self[UserNotificationClient.self] = newValue }
    }
}

extension UserNotificationClient: DependencyKey {
    public static let liveValue = Self(
        add: { try await UNUserNotificationCenter.current().add($0) },
        delegate: {
            AsyncStream { continuation in
                let delegate = Delegate(continuation: continuation)
                UNUserNotificationCenter.current().delegate = delegate
                continuation.onTermination = { [delegate] _ in }
            }
        },
        getNotificationSettings: {
            await Notification.Settings(
                rawValue: UNUserNotificationCenter.current().notificationSettings()
            )
        },
        removeDeliveredNotificationsWithIdentifiers: {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: $0)
        },
        removePendingNotificationRequestsWithIdentifiers: {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: $0)
        },
        requestAuthorization: {
            try await UNUserNotificationCenter.current().requestAuthorization(options: $0)
        }
    )
}

extension UserNotificationClient: TestDependencyKey {
    public static let previewValue = Self.noop
    
    public static let testValue = Self(
        add: XCTUnimplemented("\(Self.self).add"),
        delegate: XCTUnimplemented("\(Self.self).delegate", placeholder: .finished),
        getNotificationSettings: XCTUnimplemented(
            "\(Self.self).getNotificationSettings",
            placeholder: Notification.Settings(authorizationStatus: .notDetermined)
        ),
        removeDeliveredNotificationsWithIdentifiers: XCTUnimplemented(
            "\(Self.self).removeDeliveredNotificationsWithIdentifiers"),
        removePendingNotificationRequestsWithIdentifiers: XCTUnimplemented(
            "\(Self.self).removePendingNotificationRequestsWithIdentifiers"),
        requestAuthorization: XCTUnimplemented("\(Self.self).requestAuthorization")
    )
}

extension UserNotificationClient {
    public static let noop = Self(
        add: { _ in },
        delegate: { AsyncStream { _ in } },
        getNotificationSettings: { Notification.Settings(authorizationStatus: .notDetermined) },
        removeDeliveredNotificationsWithIdentifiers: { _ in },
        removePendingNotificationRequestsWithIdentifiers: { _ in },
        requestAuthorization: { _ in false }
    )
}

extension UserNotificationClient.Notification {
    public init(rawValue: UNNotification) {
        self.date = rawValue.date
        self.request = rawValue.request
    }
}

extension UserNotificationClient.Notification.Response {
    public init(rawValue: UNNotificationResponse) {
        self.notification = .init(rawValue: rawValue.notification)
    }
}

extension UserNotificationClient.Notification.Settings {
    public init(rawValue: UNNotificationSettings) {
        self.authorizationStatus = rawValue.authorizationStatus
    }
}

extension UserNotificationClient {
    fileprivate class Delegate: NSObject, UNUserNotificationCenterDelegate {
        let continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation
        
        init(continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation) {
            self.continuation = continuation
        }
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            self.continuation.yield(
                .didReceiveResponse(.init(rawValue: response)) { completionHandler() }
            )
        }
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            openSettingsFor notification: UNNotification?
        ) {
            self.continuation.yield(
                .openSettingsForNotification(notification.map(Notification.init(rawValue:)))
            )
        }
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            self.continuation.yield(
                .willPresentNotification(.init(rawValue: notification)) { completionHandler($0) }
            )
        }
    }
}
