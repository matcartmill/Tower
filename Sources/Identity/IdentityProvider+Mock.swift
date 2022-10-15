public final class MockIdentityProvider: IdentityProvider {
    public init() { }
    
    public func identify() async throws -> Identity {
        .init(provider: .apple, jwt: "")
    }
}
