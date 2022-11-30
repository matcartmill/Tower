import ComposableArchitecture
import CoreUI
import SwiftUI

public struct UsernameOnboardingStepView: View {
    public let store: StoreOf<UsernameOnboardingStep>

    public init(store: StoreOf<UsernameOnboardingStep>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in            
            CalloutView(
                image: Asset.Icons.tag.swiftUIImage,
                title: L10n.Onboarding.Username.title,
                details: L10n.Onboarding.Username.details,
                primaryAction: .init(
                    title: L10n.Onboarding.Button.next,
                    execute: { viewStore.send(.submitUsername, animation: .default) }
                ),
                secondaryAction: nil,
                canProceed: !viewStore.username.isEmpty
            ) {
                UnderlinedTextFieldView(
                    text: viewStore.binding(
                        get: \.username,
                        send: UsernameOnboardingStep.Action.textFieldChanged
                    ),
                    placeholder: nil
                )
                    .padding(24)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .themedBackground()
        }
    }
}
