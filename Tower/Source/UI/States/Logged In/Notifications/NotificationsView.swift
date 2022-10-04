import ComposableArchitecture
import SwiftUI

public struct NotificationsView: View {
    public let store: NotificationsStore

    public init(store: NotificationsStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in

        }
    }
}