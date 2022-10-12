import ComposableArchitecture
import DomainKit
import Foundation

public class SessionGateway {
    public func exchange(_ identity: Identity) async throws -> Session {
        .init(
            token: .init(UUID().uuidString),
            user: .init(
                username: User.receiver.username,
                metadata: .init(onboardingCompleted: true, profileImageUrl: nil)
            )
        )
    }
}

extension SessionGateway {
    static let live: SessionGateway = .init()
}

extension SessionGateway: DependencyKey {
    public static let liveValue = SessionGateway.live
}

extension DependencyValues {
  var sessionGateway: SessionGateway {
    get { self[SessionGateway.self] }
    set { self[SessionGateway.self] = newValue }
  }
}
