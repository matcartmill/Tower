import Foundation
import Toolbox

public struct User: Equatable {
    public let id: Identifier<Self>
    public var username: String
    
    public init(username: String) {
        self.id = .init()
        self.username = username
    }
}
