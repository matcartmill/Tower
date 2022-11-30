import ComposableArchitecture
import ConversationsFeature
import CoreUI
import NotificationsFeature
import SwiftUI
import TrackingFeature

public struct LoggedInView: View {
    public let store: StoreOf<LoggedIn>

    public init(store: StoreOf<LoggedIn>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                Group {
                    ConversationsView(
                        store: store.scope(
                            state: \.conversations,
                            action: LoggedIn.Action.conversations
                        )
                    )
                    .tabItem {
                        VStack {
                            Asset.Icons.conversation.swiftUIImage
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
                            Asset.Icons.task.swiftUIImage
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
                            Asset.Icons.bell.swiftUIImage
                            Text("Notifications")
                        }
                    }
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Asset.Colors.Background.base.swiftUIColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
    }
}
