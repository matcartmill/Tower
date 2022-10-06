import Foundation
import Toolbox

public struct OnboardingEnvironment {
    public let usernameEnvironment: OnboardingUsernameEnvironment
    public let profilePictureEnvironment: OnboardingProfilePictureEnvironment
    public let permissionsEnvironment: OnboardingPermissionsEnvironment
    
    public init (
        notificationsPermission: Permission<Notifications>,
        photosPermission: Permission<Photos>
    ) {
        self.usernameEnvironment = .init()
        self.profilePictureEnvironment = .init(permission: photosPermission)
        self.permissionsEnvironment = .init(permission: notificationsPermission)
    }
}
