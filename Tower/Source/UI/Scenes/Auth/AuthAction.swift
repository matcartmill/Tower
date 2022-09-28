import ComposableArchitecture

public enum AuthAction: Equatable {
    case showAuthError
    case authenticate
    case authenticationResponse(TaskResult<Session>)
}
