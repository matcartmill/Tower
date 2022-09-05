public struct AppEnvironment {}

extension AppEnvironment {
    public static let live: Self = .init()
    public static let mock: Self = .init()
}
