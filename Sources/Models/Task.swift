import Foundation
import Identifier

public struct Task: Codable, Equatable, Identifiable {
    public enum Frequency: Codable, Equatable {
        case daily, weekly, monthly
    }
    
    public let id: Identifier<Self>
    public var title: String
    public var description: String
    public var lastCompleted: Date
    public var frequency: Frequency
    
    public init(
        id: Identifier<Self> = .init(),
        title: String,
        description: String,
        lastCompleted: Date = .init(timeIntervalSince1970: 0),
        frequency: Frequency
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.lastCompleted = lastCompleted
        self.frequency = frequency
    }
}
