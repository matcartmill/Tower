import SwiftUI

@main
struct TowerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: .init(
                initialState: .init(),
                reducer: homeReducer,
                environment: .live
            ))
        }
    }
}
