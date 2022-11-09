public struct DeviceTokenRequest: Encodable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}
