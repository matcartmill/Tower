import SwiftUI

@main
struct TowerApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: .init(
                initialState: .loading(.init()),
                reducer: appReducer,
                environment: .mock
            ))
        }
    }
}
