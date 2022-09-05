public enum AppAction {
    case viewShown
    case showAuth
    case showHome(Participant)
    
    // Bridge - Auth
    
    case auth(AuthAction)
    
    // Bridge - Home
    
    case home(HomeAction)
}
