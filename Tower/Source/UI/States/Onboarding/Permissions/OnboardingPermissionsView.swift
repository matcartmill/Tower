import ComposableArchitecture
import SwiftUI

public struct OnboardingPermissionsView: View {
    public let store: OnboardingPermissionsStore

    public init(store: OnboardingPermissionsStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                Group {
                    Text("Customize your experience by opting into these services")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("The following permissions are suggested to help you get the most out of the application but are in no way required. Choose whichever services you'd like to opt into. Or none at all. Your choice.")
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
