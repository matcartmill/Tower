import Core
import Foundation

public struct IncomingConversationRequest: Equatable, Decodable, Identifiable {
    public var id: Identifier<Self> = .init()
    public let user: BasicUserDetails
    
    public init(
        id: Identifier<Self> = .init(),
        user: BasicUserDetails
    ) {
        self.id = id
        self.user = user
    }
}
