import ComposableArchitecture

extension Permissions: DependencyKey {
    public static var liveValue: Permissions {
        .init(notifications: .notifications, photos: .photos)
    }
}

extension DependencyValues {
  public var permissions: Permissions {
    get { self[Permissions.self] }
    set { self[Permissions.self] = newValue }
  }
}
