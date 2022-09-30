import DomainKit
import Foundation

public class MockSessionGateway: SessionGateway {
    public func exchange(_ identity: Identity) async throws -> Session {
        .init(
            token: .init(UUID().uuidString),
            user: .init(username: User.receiver.username)
        )
    }
}

