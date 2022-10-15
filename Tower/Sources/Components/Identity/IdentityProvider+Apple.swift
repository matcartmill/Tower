import AuthenticationServices
import Foundation

public final class AppleIdentityProvider: NSObject, IdentityProvider {
    private var checkedThrowingContinuation: CheckedContinuation<Identity, Error>?
    
    public func identify() async throws -> Identity {
        return try await withCheckedThrowingContinuation({ [weak self] (continuation: CheckedContinuation<Identity, Error>) in
            checkedThrowingContinuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            request.requestedScopes = []
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        })
    }
}

extension AppleIdentityProvider: ASAuthorizationControllerDelegate {
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let jwt = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8) else {
                checkedThrowingContinuation?.resume(throwing: IdentityError.jwtDecodingError)
                checkedThrowingContinuation = nil
                return
            }

            checkedThrowingContinuation?.resume(returning: .init(
                provider: .apple,
                jwt: jwt
            ))
            checkedThrowingContinuation = nil
            
        default:
            checkedThrowingContinuation?.resume(throwing: IdentityError.invalidProvider)
            checkedThrowingContinuation = nil
        }
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        checkedThrowingContinuation?.resume(throwing: error)
        checkedThrowingContinuation = nil
    }
}
