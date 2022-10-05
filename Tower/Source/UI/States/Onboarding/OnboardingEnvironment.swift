import Foundation

public struct OnboardingEnvironment {
    public let usernameEnvironment: OnboardingUsernameEnvironment
    public let profilePictureEnvironment: OnboardingProfilePictureEnvironment
    public let permissionsEnvironment: OnboardingPermissionsEnvironment
    
    public init (
        usernameEnvironment: OnboardingUsernameEnvironment,
        profilePictureEnvironment: OnboardingProfilePictureEnvironment,
        permissionsEnvironment: OnboardingPermissionsEnvironment
    ) {
        self.usernameEnvironment = usernameEnvironment
        self.profilePictureEnvironment = profilePictureEnvironment
        self.permissionsEnvironment = permissionsEnvironment
    }
}
