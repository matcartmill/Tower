import ComposableArchitecture
import IdentifiedCollections

public struct ComposeState: Equatable {
    @BindableState
    public var isComposingFocused = false
    public var conversation: Conversation
    public var message = ""
    public var user: Participant = .sender
}
