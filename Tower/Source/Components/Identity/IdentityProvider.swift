import Combine
import DomainKit
import Foundation

public protocol IdentityProvider {
    func identify() async throws -> Identity
}
