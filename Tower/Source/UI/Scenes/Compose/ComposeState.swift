import ComposableArchitecture
import DomainKit
import IdentifiedCollections

public struct ComposeState: Equatable {
    @BindableState
    public var isComposingFocused = false
    public var conversation: Conversation
    public var message = ""
    public var user: User
}
