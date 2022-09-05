public struct AppState: Equatable {
    public var hasLoaded = false
    public var authState: AuthState?
    public var homeState: HomeState?
}
