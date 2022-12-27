import Foundation

/**
 Used only in calls to refresh the access token with the server. This token will not authenticate against priviledged endpoints.
 */
public struct RefreshToken: Codable, Equatable, LosslessStringConvertible {
    public let description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
