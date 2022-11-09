import Foundation

public struct SendMessageRequest: Encodable {
    public let content: String
    
    public init(content: String) {
        self.content = content
    }
}
