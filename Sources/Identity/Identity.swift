public struct Identity: Encodable, Equatable {
    public enum Provider: String, Encodable {
        case apple
    }
    public let provider: Provider
    public let jwt: String
    
    public init(provider: Provider, jwt: String) {
        self.provider = provider
        self.jwt = jwt
    }
}
