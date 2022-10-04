import ComposableArchitecture
import Foundation

public typealias OnboardingProfilePictureStore = Store<OnboardingProfilePictureState, OnboardingProfilePictureAction>
public typealias OnboardingProfilePictureViewStore = ViewStore<OnboardingProfilePictureState, OnboardingProfilePictureAction>
public typealias OnboardingProfilePictureReducer = Reducer<OnboardingProfilePictureState, OnboardingProfilePictureAction, OnboardingProfilePictureEnvironment>

public let onboardingProfilePictureReducer = OnboardingProfilePictureReducer { state, action, env in
    switch action {
    case .next:
        return .none
    }
}
