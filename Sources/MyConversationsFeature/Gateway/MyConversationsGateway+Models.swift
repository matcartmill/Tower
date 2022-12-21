import Core
import Models

extension MyConversationsGateway {
    public enum Action {
        case addConversation(Conversation)
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

extension MyConversationsGateway.Event.Action {
    static let newConversation: Self = .init(rawValue: "new_conversation")
}
