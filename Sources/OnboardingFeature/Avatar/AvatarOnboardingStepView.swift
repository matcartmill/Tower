import ComposableArchitecture
import CoreUI
import SwiftUI

public struct AvatarOnboardingStepView: View {
    public let store: StoreOf<AvatarOnboardingStep>

    public init(store: StoreOf<AvatarOnboardingStep>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 32) {
                CalloutView<EmptyView>(
                    image: Asset.Icons.chatBubble.swiftUIImage,
                    title: L10n.Onboarding.Avatar.title,
                    details: L10n.Onboarding.Avatar.details,
                    primaryAction: .init(
                        title: L10n.Onboarding.Avatar.Button.title,
                        execute: { viewStore.send(.selectPhoto, animation: .default) }
                    ),
                    secondaryAction: .init(
                        title: L10n.Onboarding.Button.next,
                        execute: { viewStore.send(.next, animation: .default) }
                    ),
                    canProceed: true
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .themedBackground()
        }
    }
}
