public enum AppState: Equatable {
    case loading(AppLoadingState)
    case loggedIn(LoggedInState)
    case loggedOut(AuthState)
    case onboarding(OnboardingState)
}
