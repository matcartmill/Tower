import ComposableArchitecture
import CoreUI
import SwiftUI

public struct AuthView: View {
    public let store: StoreOf<Auth>
    
    public init(store: StoreOf<Auth>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 48) {
                Text("T O W E R")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if viewStore.isAuthenticating {
                    ProgressView()
                        .frame(height: 44)
                } else {
                    AppleSignInButton()
                        .frame(maxWidth: 375, maxHeight: 50)
                        .padding(.bottom, 40)
                        .onTapGesture { viewStore.send(.authenticate) }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .themedBackground()
            .alert(
                "Oops!",
                isPresented: viewStore.binding(
                    get: { $0.errorMessage != nil },
                    send: Auth.Action.showAuthError
                ),
                actions: { Button("Okay") {} },
                message: { Text("Something went wrong during the sign-in process.") }
            )
        }
    }
}
