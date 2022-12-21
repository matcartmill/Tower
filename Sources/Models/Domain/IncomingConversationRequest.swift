import Core
import Foundation

public struct IncomingConversationRequest: Equatable, Decodable, Identifiable {
    public let id: Identifier<Self>
    public let user: BasicUserDetails
    
    public init(
        id: Identifier<Self> = .init(),
        user: BasicUserDetails
    ) {
        self.id = id
        self.user = user
    }
}
