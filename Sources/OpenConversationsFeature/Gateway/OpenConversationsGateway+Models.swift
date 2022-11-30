import AnyCodable
import Models

extension OpenConversationsGateway {
    public enum Action {
        case removeConversation(Conversation.ID)
    }
    
    public enum Error: Swift.Error {
        case invalidUrl
    }
    
    struct Event: Decodable {
        struct Action: Decodable, RawRepresentable, Equatable {
            let rawValue: String
            
            init(rawValue: String) {
                self.rawValue = rawValue
            }
        }
        let action: Action
        let payload: [String: AnyCodable]
    }
}

extension OpenConversationsGateway.Event.Action {
    static let removeConversation: Self = .init(rawValue: "remove")
}
