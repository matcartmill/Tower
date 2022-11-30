import Foundation
import Identifier

public struct IncomingConversationRequest: Equatable, Decodable, Identifiable {
    public var id: Identifier<Self> = .init()
    public let userDetails: BasicUserDetails
    
    public init(
        id: Identifier<Self> = .init(),
        userDetails: BasicUserDetails
    ) {
        self.id = id
        self.userDetails = userDetails
    }
}
