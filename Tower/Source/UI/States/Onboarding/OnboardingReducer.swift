import ComposableArchitecture
import Foundation

public typealias OnboardingStore = Store<OnboardingState, OnboardingAction>
public typealias OnboardingViewStore = ViewStore<OnboardingState, OnboardingAction>
public typealias OnboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>

public let onboardingReducer = OnboardingReducer.combine(
    onboardingUsernameReducer.pullback(
        state: /OnboardingState.username,
        action: /OnboardingAction.username,
        environment: { $0.usernameEnvironment }
    ),
    onboardingProfilePictureReducer.pullback(
        state: /OnboardingState.profilePicture,
        action: /OnboardingAction.profilePicture,
        environment: { $0.profilePictureEnvironment }
    ),
    onboardingPermissionsReducer.pullback(
        state: /OnboardingState.permissions,
        action: /OnboardingAction.permissions,
        environment: { $0.permissionsEnvironment }
    ),
    .init { state, action, env in
        switch action {
        case .complete:
            return .none
            
        case .showUsernameOnboarding:
            state = .username(.init())
            return .none
            
        case .showProfilePictureOnboarding:
            state = .profilePicture(.init())
            return .none
            
        case .showPermissionsOnboarding:
            state = .permissions(.init())
            return .none
            
        // Bridges - Username
            
        case .username(.next):
            return .init(value: .showProfilePictureOnboarding)
            
        // Bridges - Profile Picture
            
        case .profilePicture(.skip):
            return .init(value: .showPermissionsOnboarding)
            
        case .profilePicture:
            return .none
            
        // Bridges - Permissions
            
        case .permissions(.next):
            return .init(value: .complete)
            
        case .permissions:
            return .none
        }
    }
)
