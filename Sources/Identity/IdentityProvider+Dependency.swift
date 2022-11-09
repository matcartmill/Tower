import ComposableArchitecture

public enum IdentityProviderKey: DependencyKey {
    public static let liveValue: any IdentityProvider = AppleIdentityProvider()
    public static let previewValue: any IdentityProvider = MockIdentityProvider()
}

extension DependencyValues {
    public var identityProvider: IdentityProvider {
        get { self[IdentityProviderKey.self] }
        set { self[IdentityProviderKey.self] = newValue }
    }
}
