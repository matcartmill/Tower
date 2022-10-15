import ComposableArchitecture
import CoreUI
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
                .background(
                    Asset.Colors.Background.base.swiftUIColor
                        .ignoresSafeArea()
                )
                .onAppear { viewStore.send(.load) }
        }
    }
}
