public struct AuthEnvironment {}

extension AuthEnvironment {
    public static let live = Self()
}

extension AuthEnvironment {
    public static let mock = Self(
        //
    )
}
