import ComposableArchitecture
import SwiftUI

public struct LoggedInView: View {
    public let store: LoggedInStore

    public init(store: LoggedInStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                ConversationsView(
                    store: store.scope(
                        state: \.conversationsState,
                        action: LoggedInAction.conversations
                    )
                )
                .tabItem {
                    VStack {
                        Image("icons/conversation")
                        Text("Conversations")
                    }
                }
                
                TrackingView(
                    store: store.scope(
                        state: \.trackingState,
                        action: LoggedInAction.tracking
                    )
                )
                .tabItem {
                    VStack {
                        Image("icons/task")
                        Text("Tracking")
                    }
                }
                
                NotificationsView(
                    store: store.scope(
                        state: \.notificationsState,
                        action: LoggedInAction.notifications
                    )
                )
                .tabItem {
                    VStack {
                        Image("icons/bell")
                        Text("Notifications")
                    }
                }
            }
        }
    }
}
