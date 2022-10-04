import Foundation

public enum OnboardingState: Equatable {
    case username(OnboardingUsernameState)
    case profilePicture(OnboardingProfilePictureState)
    case privacy(OnboardingPrivacyState)
    case permissions(OnboardingPermissionsState)
}
