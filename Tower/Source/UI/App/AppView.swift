import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: AppStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.authRequired {
                IfLetStore(
                    store.scope(
                        state: \.authState,
                        action: AppAction.auth
                    )
                ) {
                    AuthView(store: $0)
                } else: {
                    ProgressView()
                        .onAppear { viewStore.send(.viewShown) }
                }
            } else {
                TabView {
                    IfLetStore(
                        store.scope(
                            state: \.conversationsState,
                            action: AppAction.conversations
                        )
                    ) {
                        ConversationsView(store: $0)
                            .tabItem {
                                Text("Conversations")
                            }
                    }
                    
                    IfLetStore(
                        store.scope(
                            state: \.journalState,
                            action: AppAction.journal
                        )
                    ) {
                        JournalView(store: $0)
                            .tabItem {
                                Text("Journal")
                            }
                    }
                }
            }
        }
    }
}
