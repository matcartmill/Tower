public struct ConversationsEnvironment {}

extension ConversationsEnvironment {
    public static let live = Self()
}

extension ConversationsEnvironment {
    public static let mock = Self(
        //
    )
}
