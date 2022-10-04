import ComposableArchitecture
import Foundation

public typealias OnboardingPrivacyStore = Store<OnboardingPrivacyState, OnboardingPrivacyAction>
public typealias OnboardingPrivacyViewStore = ViewStore<OnboardingPrivacyState, OnboardingPrivacyAction>
public typealias OnboardingPrivacyReducer = Reducer<OnboardingPrivacyState, OnboardingPrivacyAction, OnboardingPrivacyEnvironment>

public let onboardingPrivacyReducer = OnboardingPrivacyReducer { state, action, env in
    switch action {
    case .next:
        return .none
    }
}
