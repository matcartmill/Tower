import Foundation
import Toolbox

public struct OnboardingPermissionsEnvironment {
    public let permission: Permission<Notifications>
    
    public init (permission: Permission<Notifications>) {
        self.permission = permission
    }
}
