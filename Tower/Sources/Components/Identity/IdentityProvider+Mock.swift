class MockIdentityProvider: IdentityProvider {
    func identify() async throws -> Identity {
        .init(provider: .apple, jwt: "")
    }
}
