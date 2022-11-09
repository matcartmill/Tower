import ComposableArchitecture
import NetworkEnvironment
import RootFeature
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
        initialState: Root.State.loading(.init()),
        reducer: Root()
    )

    var viewStore: ViewStore<Void, Root.Action> {
        ViewStore(self.store.stateless)
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        self.viewStore.send(.appDelegate(.didFinishLaunching))
        
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        self.viewStore.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        self.viewStore.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
    }
}

@main
struct TowerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    private var networkEnvironment: NetworkEnvironment {
        .current
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: self.appDelegate.store)            
        }
        .onChange(of: self.scenePhase) {
            self.appDelegate.viewStore.send(.didChangeScenePhase($0))
        }
    }
}
