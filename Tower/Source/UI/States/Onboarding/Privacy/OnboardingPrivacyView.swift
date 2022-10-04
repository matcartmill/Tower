import ComposableArchitecture
import SwiftUI

public struct OnboardingPrivacyView: View {
    public let store: OnboardingPrivacyStore

    public init(store: OnboardingPrivacyStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                Group {
                    Text("You're in control of your privacy")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Be as open or as private as you'd like. You can always update these settings later if you change your mind.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                
                Button("Next") { viewStore.send(.next, animation: .default) }
                    .frame(width: 200)
                    .buttonStyle(PrimaryButtonStyle())
                    
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
