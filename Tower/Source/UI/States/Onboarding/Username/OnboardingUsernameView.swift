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
            VStack(spacing: 16) {
                Group {
                    Text("What can we call you?")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your unique username will be used as an alias when chatting with others using the platform.")
                        .font(.body)
                        .fontWeight(.medium)
                }
                
                UnderlinedTextFieldView(text: $username, placeholder: nil)
                    .padding(24)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button("Next") { viewStore.send(.next, animation: .default) }
                    .frame(width: 200)
                    .disabled(username.isEmpty)
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
