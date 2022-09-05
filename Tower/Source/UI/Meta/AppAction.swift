public enum AppAction {
    case dataLoaded
    case viewLoaded
    
    // Bridge - Auth
    
    case auth(AuthAction)
    
    // Bridge - Home
    
    case home(HomeAction)
}
