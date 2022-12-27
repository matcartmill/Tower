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
            accessToken: {
                sessionStore.session?.accessToken ?? .init("")
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
