import ComposableArchitecture
import SwiftUI

public struct LoggedInView: View {
    public let store: StoreOf<LoggedIn>

    public init(store: StoreOf<LoggedIn>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                ConversationsView(
                    store: store.scope(
                        state: \.conversations,
                        action: LoggedIn.Action.conversations
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
                        state: \.tracking,
                        action: LoggedIn.Action.tracking
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
                        state: \.notifications,
                        action: LoggedIn.Action.notifications
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
