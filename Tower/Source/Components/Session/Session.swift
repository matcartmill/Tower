public struct Session: Equatable {
    public struct Token: Equatable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
    
    public var token: Token
    public var user: User
}
