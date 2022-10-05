import Foundation
import Toolbox

public struct AppEnvironment {
    // MARK: - Components: Permissions
    
    private let photosPermission: Permission<Photos>
    private let notificationsPermission: Permission<Notifications>
    
    // MARK: - Components: Identity & Session
    
    private let identityProvider: IdentityProvider
    private let sessionStore: SessionStore
    private let sessionGateway: SessionGateway
    
    // MARK: - Environments
    
    public let authEnvironment: AuthEnvironment
    public let loggedInEnvironment: LoggedInEnvironment
    public let onboardingEnvironment: OnboardingEnvironment
    
    public init(
        photosPermission: Permission<Photos>,
        notificationsPermission: Permission<Notifications>,
        identityProvider: IdentityProvider,
        sessionGateway: SessionGateway
    ) {
        let sessionStore = SessionStore()
        
        self.photosPermission = photosPermission
        self.notificationsPermission = notificationsPermission
        self.identityProvider = identityProvider
        self.sessionStore = sessionStore
        self.sessionGateway = sessionGateway
        
        self.authEnvironment = .init(
            identityProvider: identityProvider,
            sessionGateway: sessionGateway,
            sessionStore: sessionStore
        )
        
        self.loggedInEnvironment = .init(
            conversationsEnvironment: .init(),
            trackingEnvironment: .init(),
            notificationsEnvironment: .init()
        )
        
        self.onboardingEnvironment = .init(
            usernameEnvironment: .init(),
            profilePictureEnvironment: .init(),
            permissionsEnvironment: .init(permission: notificationsPermission)
        )
    }
}

extension AppEnvironment {
    public static var live: Self {
        .init(
            photosPermission: .photos,
            notificationsPermission: .notifications,
            identityProvider: AppleIdentityProvider(),
            sessionGateway: LiveSessionGateway()
        )
    }
    
    public static var mock: Self {
        .init(
            photosPermission: .init(name: "Photos", status: { .authorized }, requestAccess: { _ in }),
            notificationsPermission: .init(name: "Notifications", status: { .authorized }, requestAccess: { _ in }),
            identityProvider: MockIdentityProvider(),
            sessionGateway: MockSessionGateway()
        )
    }
}
