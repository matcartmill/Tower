import ComposableArchitecture
import Foundation

public typealias OnboardingProfilePictureStore = Store<OnboardingProfilePictureState, OnboardingProfilePictureAction>
public typealias OnboardingProfilePictureViewStore = ViewStore<OnboardingProfilePictureState, OnboardingProfilePictureAction>
public typealias OnboardingProfilePictureReducer = Reducer<OnboardingProfilePictureState, OnboardingProfilePictureAction, OnboardingProfilePictureEnvironment>

public let onboardingProfilePictureReducer = OnboardingProfilePictureReducer { state, action, env in
    switch action {
    case .requestPermission:
        env.permission.requestAccess { _ in }
        
        return .none
        
    case .selectPhoto:
        switch env.permission.status() {
        case .unknown:
            return .init(value: .requestPermission)
            
        case .authorized, .denied:
            return .none
        }
        
    case .skip:
        return .none
    }
}
