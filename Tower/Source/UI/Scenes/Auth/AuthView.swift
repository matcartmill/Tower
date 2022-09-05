import AuthenticationServices
import ComposableArchitecture
import SwiftUI

struct AuthView: View {
    @Environment (\.colorScheme) var colorScheme
    let store: AuthStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 48) {
                // App title and welcome
                Group {
                    VStack {
                        Text("TOWER")
                            .font(.system(size: 60).bold())
                            .foregroundColor(Color("colors/content/primary"))
                        
                        Text("Let's get started by logging in")
                            .font(.callout)
                            .foregroundColor(Color("colors/content/primary"))
                    }
                }
                
                // Loading or Login button
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

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(store: .init(
            initialState: .init(),
            reducer: authReducer,
            environment: .live
        ))
    }
}
