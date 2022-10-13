import SwiftUI

@main
struct TowerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .loading(.init()),
                    reducer: Root()
                )
            )
        }
    }
}
