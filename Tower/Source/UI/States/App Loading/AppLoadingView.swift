import ComposableArchitecture
import SwiftUI

public struct AppLoadingView: View {
    public let store: AppLoadingStore

    public init(store: AppLoadingStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ProgressView()
                .onAppear { viewStore.send(.load) }
        }
    }
}
