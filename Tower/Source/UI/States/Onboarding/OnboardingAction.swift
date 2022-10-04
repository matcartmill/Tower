public enum OnboardingAction {
    case complete
    
    case showUsernameOnboarding
    case showProfilePictureOnboarding
    case showPrivacyOnboarding
    case showPermissionsOnboarding
    
    // Bridge - Username
    
    case username(OnboardingUsernameAction)
    
    // Bridge - Profile Picture
    
    case profilePicture(OnboardingProfilePictureAction)
    
    // Bridge - Privacy
    
    case privacy(OnboardingPrivacyAction)
    
    // Bridge - Permissions
    
    case permissions(OnboardingPermissionsAction)
}
