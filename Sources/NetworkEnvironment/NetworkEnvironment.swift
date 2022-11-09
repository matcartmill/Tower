public struct NetworkEnvironment {
    public let apiProtocol: String
    public let apiHost: String
    public let apiPort: Int?
    public let socketProtocol: String
}

extension NetworkEnvironment {
    public static let local = Self(
        apiProtocol: "http",
        apiHost: "localhost",
        apiPort: 8080,
        socketProtocol: "ws"
    )
    
    public static let development = Self(
        apiProtocol: "https",
        apiHost: "api.dev.towerapp.io",
        apiPort: nil,
        socketProtocol: "wss"
    )
    
    public static let production = Self(
        apiProtocol: "https",
        apiHost: "api.towerapp.io",
        apiPort: nil,
        socketProtocol: "wss"
    )
}

extension NetworkEnvironment {
    public static var current: Self { .development }
}
