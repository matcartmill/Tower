import Combine
import Foundation

public struct AuthEnvironment {
    public let identityProvider: IdentityProvider
    public let sessionGateway: SessionGateway
    public let sessionStore: SessionStore
}
