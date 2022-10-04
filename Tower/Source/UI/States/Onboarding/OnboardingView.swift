import ComposableArchitecture
import SwiftUI

public struct OnboardingView: View {
    public let store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        SwitchStore(store) {
            CaseLet(
                state: /OnboardingState.username,
                action: OnboardingAction.username
            ) {
                OnboardingUsernameView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                    )
            }
            CaseLet(
                state: /OnboardingState.profilePicture,
                action: OnboardingAction.profilePicture
            ) {
                OnboardingProfilePictureView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                    )
            }
            CaseLet(
                state: /OnboardingState.privacy,
                action: OnboardingAction.privacy
            ) {
                OnboardingPrivacyView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                    )
            }
            CaseLet(
                state: /OnboardingState.permissions,
                action: OnboardingAction.permissions
            ) {
                OnboardingPermissionsView(store: $0)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing), removal: .opacity)
                    )
            }
        }
    }
}
