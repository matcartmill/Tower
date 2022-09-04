public struct ConversationEnvironment {}

extension ConversationEnvironment {
    public static let live = Self()
}

extension ConversationEnvironment {
    public static let mock = Self(
        //
    )
}
