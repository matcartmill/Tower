import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: AppStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.homeState != nil {
                IfLetStore(
                    store.scope(
                        state: \.homeState,
                        action: AppAction.home
                    )
                ) {
                    HomeView(store: $0)
                }
            } else if viewStore.authState != nil {
                IfLetStore(
                    store.scope(
                        state: \.authState,
                        action: AppAction.auth
                    )
                ) {
                    AuthView(store: $0)
                }
            } else {
                ProgressView()
                    .onAppear { viewStore.send(.viewShown) }
            }
        }
    }
}
