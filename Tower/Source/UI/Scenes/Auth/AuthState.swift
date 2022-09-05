public struct AuthState: Equatable {
    var errorMessage: String?
    var isAuthenticating = false
    var user: Participant?
}