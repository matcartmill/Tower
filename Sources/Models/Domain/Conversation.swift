import Core
import Foundation

public struct Conversation: Decodable, Identifiable, Equatable {
    public struct Category: RawRepresentable, Codable, Equatable {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    public let id: Identifier<Self>
    public var author: BasicUserDetails
    public var partner: BasicUserDetails?
    public var messages: [Message]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: Identifier<Self>,
        author: BasicUserDetails,
        partner: BasicUserDetails?,
        messages: [Message],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.author = author
        self.partner = partner
        self.messages = messages
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Conversation.Category {
    public static let none: Self = .init(rawValue: "")
}
