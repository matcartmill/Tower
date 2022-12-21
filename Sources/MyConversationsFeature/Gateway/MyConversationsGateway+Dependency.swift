import ComposableArchitecture
import Foundation
import JWT
import NetworkEnvironment

extension MyConversationsGateway: DependencyKey {
    public static var liveValue: MyConversationsGateway {
        @Dependency(\.urlSession) var urlSession
        @Dependency(\.sessionStore) var sessionStore
        
        return MyConversationsGateway(
            session: urlSession,
            environment: .current,
            jwt: {
                sessionStore.session?.jwt ?? .init(token: "")
            }
        )
    }
}

extension DependencyValues {
  public var myConversationsGateway: MyConversationsGateway {
    get { self[MyConversationsGateway.self] }
    set { self[MyConversationsGateway.self] = newValue }
  }
}
