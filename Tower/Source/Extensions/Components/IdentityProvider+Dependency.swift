import ComposableArchitecture

enum IdentityProviderKey: DependencyKey {
    static let liveValue: any IdentityProvider = AppleIdentityProvider()
    static let previewValue: any IdentityProvider = MockIdentityProvider()
}

extension DependencyValues {
  var identityProvider: IdentityProvider {
    get { self[IdentityProviderKey.self] }
    set { self[IdentityProviderKey.self] = newValue }
  }
}
