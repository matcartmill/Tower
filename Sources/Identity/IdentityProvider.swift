import Combine
import Foundation

public protocol IdentityProvider {
    func identify() async throws -> Identity
}
