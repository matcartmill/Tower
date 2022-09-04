public struct HomeEnvironment {}

extension HomeEnvironment {
    public static let live = Self()
}

extension HomeEnvironment {
    public static let mock = Self(
        //
    )
}
