public struct APIError: Error, Decodable, Equatable {
    public let error: String

    public init(error: String) {
        self.error = error
    }
}

extension APIError {
    public static let noResponse = Self(error: "NO_RESPONSE")
    public static let invalidStatusCode = Self(error: "INVALID_STATUS_CODE")
    public static let usernameTaken = Self(error: "ACCOUNT_USERNAME_TAKEN")
    public static let usernameInvalid = Self(error: "ACCOUNT_USERNAME_INVALID")
}
