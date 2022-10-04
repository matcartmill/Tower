import DomainKit

public enum AppAction {
    // Experience
    
    case showAuth
    case showLoggedInExperience(User)
    case showOnboardingExperience(User)
    
    // Bridge - Auth
    
    case auth(AuthAction)
    
    // Bridge - Conversations (List)
    
    case loggedIn(LoggedInAction)
    
    // Bridge - Onboarding
    
    case onboarding(OnboardingAction)
    
    // Bridge - Loading
    
    case loading(AppLoadingAction)
}
