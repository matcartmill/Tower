import AnyCodable
import Models

extension ConversationGateway {
    public enum Action {
        case addMessage(Message)
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

extension ConversationGateway.Event.Action {
    static let newMessage: Self = .init(rawValue: "new_message")
}
