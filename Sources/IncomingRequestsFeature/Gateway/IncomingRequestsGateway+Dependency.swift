import ComposableArchitecture
import Foundation
import JWT
import NetworkEnvironment

extension IncomingRequestsGateway: DependencyKey {
    public static var liveValue: IncomingRequestsGateway {
        @Dependency(\.urlSession) var urlSession
        @Dependency(\.sessionStore) var sessionStore
        
        return IncomingRequestsGateway(
            session: urlSession,
            environment: .current,
            accessToken: {
                sessionStore.session?.accessToken ?? .init("")
            }
        )
    }
}

extension DependencyValues {
  public var incomingRequestsGateway: IncomingRequestsGateway {
    get { self[IncomingRequestsGateway.self] }
    set { self[IncomingRequestsGateway.self] = newValue }
  }
}
