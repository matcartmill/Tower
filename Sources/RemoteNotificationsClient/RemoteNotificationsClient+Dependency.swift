import ComposableArchitecture
import UIKit
import XCTestDynamicOverlay

extension DependencyValues {
    public var remoteNotifications: RemoteNotificationsClient {
        get { self[RemoteNotificationsClient.self] }
        set { self[RemoteNotificationsClient.self] = newValue }
    }
}

@available(iOSApplicationExtension, unavailable)
extension RemoteNotificationsClient: DependencyKey {
    public static let liveValue = Self(
        isRegistered: {
            await UIApplication.shared.isRegisteredForRemoteNotifications
        },
        register: {
            await UIApplication.shared.registerForRemoteNotifications()
        },
        unregister: {
            await UIApplication.shared.unregisterForRemoteNotifications()
        }
    )
}

extension RemoteNotificationsClient: TestDependencyKey {
    public static let previewValue = Self.noop
    
    public static let testValue = Self(
        isRegistered: XCTUnimplemented("\(Self.self).isRegistered", placeholder: false),
        register: XCTUnimplemented("\(Self.self).register"),
        unregister: XCTUnimplemented("\(Self.self).unregister")
    )
}

extension RemoteNotificationsClient {
    public static let noop = Self(
        isRegistered: { true },
        register: {},
        unregister: {
            
        }
    )
}
