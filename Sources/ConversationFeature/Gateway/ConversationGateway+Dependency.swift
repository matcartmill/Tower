import ComposableArchitecture
import Foundation
import JWT
import NetworkEnvironment

extension ConversationGateway: DependencyKey {
    public static var liveValue: ConversationGateway {
        @Dependency(\.urlSession) var urlSession
        @Dependency(\.sessionStore) var sessionStore
        
        return ConversationGateway(
            session: urlSession,
            environment: .current,
            jwt: {
                sessionStore.session?.jwt ?? .init(token: "")
            }
        )
    }
}

extension DependencyValues {
  public var conversationGateway: ConversationGateway {
    get { self[ConversationGateway.self] }
    set { self[ConversationGateway.self] = newValue }
  }
}
