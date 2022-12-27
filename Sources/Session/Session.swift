import JWT
import Models

public struct Session: Equatable {
    public var accessToken: AccessToken
    public var user: User
    
    public init(accessToken: AccessToken, user: User) {
        self.accessToken = accessToken
        self.user = user
    }
}
