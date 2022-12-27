import AppLoadingFeature
import ComposableArchitecture
import ConversationsFeature
import CoreUI
import LoggedInFeature
import OnboardingFeature
import SignInFeature
import SwiftUI

public struct RootView: View {
    public let store: StoreOf<Root>
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    public var body: some View {
        SwitchStore(store) {
            CaseLet(state: /Root.State.loading, action: Root.Action.loading) {
                AppLoadingView(store: $0)
            }
            CaseLet(state: /Root.State.loggedOut, action: Root.Action.signIn) {
                SignInView(store: $0)
            }
            CaseLet(state: /Root.State.loggedIn, action: Root.Action.conversations) {
                ConversationsView(store: $0)
            }
            CaseLet(state: /Root.State.onboarding, action: Root.Action.onboarding) {
                OnboardingView(store: $0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
    }
}
