import DomainKit

class MockIdentityProvider: IdentityProvider {
    func identify() async throws -> Identity {
        .init(id: .init(), jwt: "")
    }
}
