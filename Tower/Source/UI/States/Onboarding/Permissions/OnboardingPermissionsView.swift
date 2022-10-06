import ComposableArchitecture
import SwiftUI

public struct OnboardingPermissionsView: View {
    public let store: OnboardingPermissionsStore

    public init(store: OnboardingPermissionsStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView<EmptyView>(
                image: Image("icons/notification-indicator"),
                title: "Enhance your experience by opting into push notifications",
                details: "We'll send you notifications when you pair with someone for a conversation or when someone replies to your post.",
                primaryAction: .init(
                    title: "Enable Push Notifications",
                    execute: { viewStore.send(.requestPermission, animation: .default) }
                ),
                secondaryAction: .init(
                    title: "Finish up",
                    execute: { viewStore.send(.next, animation: .default) }
                ),
                canProceed: true
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(
                Color("colors/background/base")
                    .ignoresSafeArea()
            )
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}
