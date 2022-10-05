import ComposableArchitecture
import SwiftUI

public struct OnboardingPermissionsView: View {
    public let store: OnboardingPermissionsStore

    public init(store: OnboardingPermissionsStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 32) {
               OnboardingIconView(image: Image("icons/notification-indicator"))
                
                Group {
                    Text("Enhance your experience by opting into push notifications")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("We'll send you notifications when you pair with someone for a conversation or when someone replies to your post.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                
                Button("Enable Push Notifications") { viewStore.send(.next, animation: .default) }
                    .frame(width: 300)
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Skip for now") { viewStore.send(.next, animation: .default) }
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
