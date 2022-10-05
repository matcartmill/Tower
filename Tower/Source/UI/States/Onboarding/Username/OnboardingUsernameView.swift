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
            VStack(spacing: 32) {
                OnboardingIconView(image: Image("icons/tag"))
                
                Group {
                    Text("What should we call you?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("colors/content/primary"))
                    
                    Text("Your unique username will be used as an alias when chatting with others using the platform.")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color("colors/content/secondary"))
                }
                
                UnderlinedTextFieldView(text: $username, placeholder: nil)
                    .padding(24)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button("Next") { viewStore.send(.next, animation: .default) }
                    .frame(width: 200)
                    .disabled(username.isEmpty)
                    .buttonStyle(SecondaryButtonStyle())
                    
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
