import Core
import Models

extension IncomingRequestsGateway {
    public enum Action {
        case addRequest(IncomingConversationRequest)
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

extension IncomingRequestsGateway.Event.Action {
    static let newRequest: Self = .init(rawValue: "new_request")
}
