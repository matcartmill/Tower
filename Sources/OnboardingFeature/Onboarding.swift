import ComposableArchitecture
import Foundation

public struct Onboarding: ReducerProtocol {
    public enum State: Equatable {
        case username(UsernameOnboardingStep.State)
        case avatar(AvatarOnboardingStep.State)
        case notifications(NotificationsOnboardingStep.State)
    }
    
    public enum Action {
        case complete
        case showUsernameOnboarding
        case showProfilePictureOnboarding
        case showPermissionsOnboarding
        
        // Bridges
        
        case username(UsernameOnboardingStep.Action)
        case avatar(AvatarOnboardingStep.Action)
        case notifications(NotificationsOnboardingStep.Action)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(self.core)
            .ifCaseLet(/State.username, action: /Action.username) {
                UsernameOnboardingStep()
            }
            .ifCaseLet(/State.avatar, action: /Action.avatar) {
                AvatarOnboardingStep()
            }
            .ifCaseLet(/State.notifications, action: /Action.notifications) {
                NotificationsOnboardingStep()
            }
    }
    
    func core(state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .complete:
            return .none
            
        case .showUsernameOnboarding:
            state = .username(.init())
            return .none
            
        case .showProfilePictureOnboarding:
            state = .avatar(.init())
            return .none
            
        case .showPermissionsOnboarding:
            state = .notifications(.init())
            return .none
            
        // Bridges - Username
            
        case .username(.next):
            return .init(value: .showProfilePictureOnboarding)
            
        // Bridges - Profile Picture
            
        case .avatar(.next):
            return .init(value: .showPermissionsOnboarding)
            
        case .avatar:
            return .none
            
        // Bridges - Permissions
            
        case .notifications(.next):
            return .init(value: .complete)
            
        case .notifications:
            return .none
        }
    }
}
