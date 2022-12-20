import Core
import Foundation

public struct OutgoingConversationRequest: Equatable, Decodable, Identifiable {
    public var id: Identifier<Self> = .init()
    public let summary: ConversationSummary
    
    public init(
        id: Identifier<Self> = .init(),
        summary: ConversationSummary
    ) {
        self.id = id
        self.summary = summary
    }
}
