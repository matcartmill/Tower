public enum OnboardingAction {
    case complete
    
    case showUsernameOnboarding
    case showProfilePictureOnboarding
    case showPermissionsOnboarding
    
    // Bridge - Username
    
    case username(OnboardingUsernameAction)
    
    // Bridge - Profile Picture
    
    case profilePicture(OnboardingProfilePictureAction)
    
    // Bridge - Permissions
    
    case permissions(OnboardingPermissionsAction)
}
