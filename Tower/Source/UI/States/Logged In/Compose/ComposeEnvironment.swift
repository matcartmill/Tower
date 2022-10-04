public struct ComposeEnvironment {}

extension ComposeEnvironment {
    public static let live = Self()
}

extension ComposeEnvironment {
    public static let mock = Self(
        //
    )
}
