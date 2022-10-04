public struct AccountEnvironment {}

extension AccountEnvironment {
    public static let live: Self = .init()
    public static let mock: Self = .init()
}
