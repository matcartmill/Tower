import Foundation

public struct CreateConversationRequest: Encodable {
    public let message: SendMessageRequest
    
    public init(message: SendMessageRequest) {
        self.message = message
    }
}
