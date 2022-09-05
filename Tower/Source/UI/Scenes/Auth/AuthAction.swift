public enum AuthAction: Equatable {
    case showAuthError
    case failed(String)
    case authenticate
    case succeeded
}
