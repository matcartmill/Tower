import ComposableArchitecture
import SwiftUI

public struct OnboardingProfilePictureView: View {
    public let store: OnboardingProfilePictureStore

    public init(store: OnboardingProfilePictureStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                Group {
                    Text("Want to spruce up your profile a bit?")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Adding a profile picture gives a face to your (awesome) name, but we understand if you'd rather be private.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                
                Button("Next") { viewStore.send(.next) }
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
