public enum AppAction {
    case viewShown
    case showAuth
    case showHome(User)
    
    // Bridge - Auth
    
    case auth(AuthAction)
    
    // Bridge - Home
    
    case home(HomeAction)
}
