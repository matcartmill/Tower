import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: AppStore
    
    var body: some View {
        SwitchStore(store) {
            CaseLet(state: /AppState.loading, action: AppAction.loading) {
                AppLoadingView(store: $0)
            }
            CaseLet(state: /AppState.loggedOut, action: AppAction.auth) {
                AuthView(store: $0)
            }
            CaseLet(state: /AppState.loggedIn, action: AppAction.loggedIn) {
                LoggedInView(store: $0)
            }
            CaseLet(state: /AppState.onboarding, action: AppAction.onboarding) {
                OnboardingView(store: $0)
            }
        }
    }
}
