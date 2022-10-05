import Foundation

public enum OnboardingState: Equatable {
    case username(OnboardingUsernameState)
    case profilePicture(OnboardingProfilePictureState)
    case permissions(OnboardingPermissionsState)
}
