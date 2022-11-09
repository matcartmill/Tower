import ComposableArchitecture

extension SessionStore: DependencyKey {
    public static let liveValue = SessionStore()
}

extension DependencyValues {
    public var sessionStore: SessionStore {
        get { self[SessionStore.self] }
        set { self[SessionStore.self] = newValue }
    }
}
