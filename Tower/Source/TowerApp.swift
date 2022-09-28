import SwiftUI

@main
struct TowerApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: .init(
                initialState: .init(),
                reducer: appReducer,
                environment: .mock
            ))
        }
    }
}
