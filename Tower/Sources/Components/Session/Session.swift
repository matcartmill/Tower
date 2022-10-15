public struct Session: Equatable {
    public var jwt: JWT
    public var user: User
    
    public init(jwt: JWT, user: User) {
        self.jwt = jwt
        self.user = user
    }
}
