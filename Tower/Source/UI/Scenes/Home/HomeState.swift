import IdentifiedCollections

public struct HomeState: Equatable {
    public var conversations: IdentifiedArrayOf<ConversationState> = [
        .init(conversation:
            .init(
                participants: [.sender, .receiver],
                messages: [
                    .init(
                        content: "Hey everyone, I’ve got something on my mind that I would love to share. Please bear with me, this could get a bit lengthy.",
                        sender: Participant.sender.id
                    ),
                    .init(
                        content: "No worries! Feel free to vent. I’m here to listen!",
                        sender: Participant.receiver.id
                    ),
                    .init(
                        content: "Vent all you need.",
                        sender: Participant.receiver.id
                    ),
                ]
            )
        )
    ]
    
    public var newConversation: ComposeState?
    public var selectedConversation: ConversationState?
    
    public init() { }
}
