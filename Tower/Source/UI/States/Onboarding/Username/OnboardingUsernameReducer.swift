import ComposableArchitecture
import Foundation

public typealias OnboardingUsernameStore = Store<OnboardingUsernameState, OnboardingUsernameAction>
public typealias OnboardingUsernameViewStore = ViewStore<OnboardingUsernameState, OnboardingUsernameAction>
public typealias OnboardingUsernameReducer = Reducer<OnboardingUsernameState, OnboardingUsernameAction, OnboardingUsernameEnvironment>

public let onboardingUsernameReducer = OnboardingUsernameReducer { state, action, env in
    switch action {
    case .next:
        return .none
    }
}
