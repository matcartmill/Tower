import Foundation

public struct Message: Equatable, Identifiable {
    public let id: Identifier<Self>
    public let content: String
    public let sender: Identifier<Participant>
    
    public init(content: String, sender: Identifier<Participant>) {
        self.id = .init()
        self.content = content
        self.sender = sender
    }
}
