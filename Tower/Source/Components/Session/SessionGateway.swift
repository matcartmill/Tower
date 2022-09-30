import DomainKit

public protocol SessionGateway {
    func exchange(_ identity: Identity) async throws -> Session
}

