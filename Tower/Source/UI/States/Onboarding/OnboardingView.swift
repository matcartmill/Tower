import ComposableArchitecture
import SwiftUI

public struct OnboardingView: View {
    public let store: StoreOf<Onboarding>

    public init(store: StoreOf<Onboarding>) {
        self.store = store
    }

    public var body: some View {
        SwitchStore(store) {
            CaseLet(
                state: /Onboarding.State.username,
                action: Onboarding.Action.username
            ) {
                UsernameOnboardingStepView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .leading))
                    )
            }
            CaseLet(
                state: /Onboarding.State.avatar,
                action: Onboarding.Action.avatar
            ) {
                AvatarOnboardingStepView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                    )
            }
            CaseLet(
                state: /Onboarding.State.notifications,
                action: Onboarding.Action.notifications
            ) {
                NotificationsOnboardingStepView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .bottom).combined(with: .opacity))
                    )
            }
        }
    }
}
