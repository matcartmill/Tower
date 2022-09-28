import Combine
import Foundation

public struct AuthEnvironment {
    public let mainQueue: DispatchQueue
    public let identityProvider: IdentityProvider
    public let sessionGateway: SessionGateway
    public let sessionStore: SessionStore
}

extension AuthEnvironment {
    public static let live = Self(
        mainQueue: .main,
        identityProvider: AppleIdentityProvider(),
        sessionGateway: LiveSessionGateway(),
        sessionStore: SessionStore()
    )
}

extension AuthEnvironment {
    public static let mock = Self(
        mainQueue: .main,
        identityProvider: AppleIdentityProvider(),
        sessionGateway: MockSessionGateway(),
        sessionStore: SessionStore()
    )
}
