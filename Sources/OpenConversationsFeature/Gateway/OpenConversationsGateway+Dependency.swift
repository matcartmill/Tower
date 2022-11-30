import ComposableArchitecture
import Foundation
import JWT
import NetworkEnvironment

extension OpenConversationsGateway: DependencyKey {
    public static var liveValue: OpenConversationsGateway {
        @Dependency(\.urlSession) var urlSession
        @Dependency(\.sessionStore) var sessionStore
        
        return OpenConversationsGateway(
            session: urlSession,
            environment: .current,
            jwt: {
                sessionStore.session?.jwt ?? .init(token: "")
            }
        )
    }
}

extension DependencyValues {
  public var openConversationsGateway: OpenConversationsGateway {
    get { self[OpenConversationsGateway.self] }
    set { self[OpenConversationsGateway.self] = newValue }
  }
}
