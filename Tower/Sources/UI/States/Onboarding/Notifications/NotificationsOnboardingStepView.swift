import ComposableArchitecture
import SwiftUI

public struct NotificationsOnboardingStepView: View {
    public let store: StoreOf<NotificationsOnboardingStep>

    public init(store: StoreOf<NotificationsOnboardingStep>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView<EmptyView>(
                image: Asset.Icons.notificationIndicator.swiftUIImage,
                title: L10n.Onboarding.Notifications.title,
                details: L10n.Onboarding.Notifications.details,
                primaryAction: .init(
                    title: L10n.Onboarding.Notifications.Button.title,
                    execute: { viewStore.send(.requestPermission, animation: .default) }
                ),
                secondaryAction: .init(
                    title: L10n.Onboarding.Button.finishUp,
                    execute: { viewStore.send(.next, animation: .default) }
                ),
                canProceed: true
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}
