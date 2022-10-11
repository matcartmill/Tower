import ComposableArchitecture
import SwiftUI

public struct AppLoadingView: View {
    public let store: StoreOf<AppLoading>

    public init(store: StoreOf<AppLoading>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("colors/background/base").ignoresSafeArea())
                .onAppear { viewStore.send(.load) }
        }
    }
}
