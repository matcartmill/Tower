public struct JWT: Codable, Equatable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}
