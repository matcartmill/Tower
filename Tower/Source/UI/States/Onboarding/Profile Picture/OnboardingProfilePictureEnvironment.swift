import Foundation
import Toolbox

public struct OnboardingProfilePictureEnvironment {
    public let permission: Permission<Photos>
    
    public init (permission: Permission<Photos>) {
        self.permission = permission
    }
}
