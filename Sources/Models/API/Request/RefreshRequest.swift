import Foundation

public struct RefreshRequest: Encodable {
    public let jwt: String
    
    public init(jwt: String) {
        self.jwt = jwt
    }
}
