import AuthenticationServices
import ComposableArchitecture
import SwiftUI

struct AuthView: View {
    let store: AuthStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 48) {
                if viewStore.isAuthenticating {
                    ProgressView()
                        .frame(height: 44)
                } else {
                    AppleSignInButton()
                        .frame(width: 260, height: 44)
                        .onTapGesture { viewStore.send(.authenticate) }
                }
            }
            .padding()
            .alert(
                "Oops!",
                isPresented: viewStore.binding(
                    get: { $0.errorMessage != nil },
                    send: AuthAction.showAuthError
                ),
                actions: { Button("Okay") {} },
                message: { Text("Something went wrong during the sign-in process.") }
            )
        }
    }
}
