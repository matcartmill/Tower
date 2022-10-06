import ComposableArchitecture
import SwiftUI

public struct OnboardingUsernameView: View {
    @State private var username = ""
    public let store: OnboardingUsernameStore

    public init(store: OnboardingUsernameStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView(
                image: .init("icons/tag"),
                title: "What should we call you?",
                details: "Your unique username will be used as an alias when chatting with others using the platform.",
                primaryAction: .init(title: "Next", execute: { viewStore.send(.next, animation: .default) }),
                secondaryAction: nil,
                canProceed: !username.isEmpty
            ) {
                UnderlinedTextFieldView(text: $username, placeholder: nil)
                    .padding(24)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
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
