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
                OnboardingIconView(image: Image("icons/chat-bubble"))
                
                Group {
                    Text("Want to spruce up your profile a bit?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("colors/content/primary"))
                        .multilineTextAlignment(.center)
                    
                    Text("Adding a profile picture puts a face to your name, but we understand if you'd rather be private.")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color("colors/content/secondary"))
                        .multilineTextAlignment(.center)
                }
                
                Button("Choose a photo") { viewStore.send(.selectPhoto) }
                    .frame(width: 200)
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Next") { viewStore.send(.skip, animation: .default) }
                    .frame(width: 200)
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
