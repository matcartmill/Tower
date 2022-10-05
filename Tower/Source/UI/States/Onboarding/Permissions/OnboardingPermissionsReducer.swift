import ComposableArchitecture
import Foundation

public typealias OnboardingPermissionsStore = Store<OnboardingPermissionsState, OnboardingPermissionsAction>
public typealias OnboardingPermissionsViewStore = ViewStore<OnboardingPermissionsState, OnboardingPermissionsAction>
public typealias OnboardingPermissionsReducer = Reducer<OnboardingPermissionsState, OnboardingPermissionsAction, OnboardingPermissionsEnvironment>

public let onboardingPermissionsReducer = OnboardingPermissionsReducer { state, action, env in
    switch action {
    case .next:
        return .none
        
    case .requestPermission:
        env.permission.requestAccess { _ in }
        return .none
        
    case .viewAppeared:
        state.pushOptInState = env.permission.status()
        return .none
    }
}
