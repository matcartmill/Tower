import AuthenticationServices
import SwiftUI

public struct AppleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
  
    public init() { }
    
    public func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(
            type: .continue,
            style: colorScheme == .dark ? .white : .black
        )
    }

    public func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
