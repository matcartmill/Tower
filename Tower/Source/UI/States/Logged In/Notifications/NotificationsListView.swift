import ComposableArchitecture
import SwiftUI

public struct NotificationsView: View {
    public let store: StoreOf<NotificationsList>

    public init(store: StoreOf<NotificationsList>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Color("colors/background/base").ignoresSafeArea()
        }
    }
}
