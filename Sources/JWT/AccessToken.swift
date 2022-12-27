import Foundation

/**
 Used to gain access to priviledged endpoints. Cannot be use to refresh itself or generate a new token.
 */
public struct AccessToken: Codable, Equatable, LosslessStringConvertible {
    public let description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
