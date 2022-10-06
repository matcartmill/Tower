import ComposableArchitecture
import SwiftUI

public struct OnboardingProfilePictureView: View {
    public let store: OnboardingProfilePictureStore

    public init(store: OnboardingProfilePictureStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 32) {
                CalloutView<EmptyView>(
                    image: .init("icons/chat-bubble"),
                    title: "Want to spruce up your profile a bit?",
                    details: "Adding a profile picture puts a face to your name, but we understand if you'd rather be private.",
                    primaryAction: .init(
                        title: "Choose a photo",
                        execute: { viewStore.send(.selectPhoto, animation: .default) }
                    ),
                    secondaryAction: .init(
                        title: "Next",
                        execute: { viewStore.send(.next, animation: .default) }
                    ),
                    canProceed: true
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(
                Color("colors/background/base")
                    .ignoresSafeArea()
            )
        }
    }
}
