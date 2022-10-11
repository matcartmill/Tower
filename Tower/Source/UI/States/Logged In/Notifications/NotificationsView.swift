import ComposableArchitecture
import SwiftUI

public struct NotificationsView: View {
    public let store: StoreOf<Notifications>

    public init(store: StoreOf<Notifications>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Color("colors/background/base").ignoresSafeArea()
        }
    }
}
