import ComposableArchitecture
import Foundation

public typealias OnboardingStore = Store<OnboardingState, OnboardingAction>
public typealias OnboardingViewStore = ViewStore<OnboardingState, OnboardingAction>
public typealias OnboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>

public let onboardingReducer = OnboardingReducer.combine(
    onboardingUsernameReducer.pullback(
        state: /OnboardingState.username,
        action: /OnboardingAction.username,
        environment: { _ in .init() }
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
            
        case .showPrivacyOnboarding:
            state = .privacy(.init())
            return .none
            
        case .showPermissionsOnboarding:
            state = .permissions(.init())
            return .none
            
        // Bridges - Username
            
        case .username(.next):
            return .init(value: .showProfilePictureOnboarding)
            
        // Bridges - Profile Picture
            
        case .profilePicture(.next):
            return .init(value: .showPrivacyOnboarding)
            
        // Bridges - Privacy
            
        case .privacy(.next):
            return .init(value: .showPermissionsOnboarding)
            
        // Bridges - Permissions
            
        case .permissions(.next):
            return .init(value: .complete)
        }
    }
)
