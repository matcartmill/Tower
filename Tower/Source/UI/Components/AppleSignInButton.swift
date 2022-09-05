import AuthenticationServices
import SwiftUI

struct AppleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
  
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(
            type: .continue,
            style: colorScheme == .dark ? .white : .black
        )
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
