import ComposableArchitecture
import Foundation
import Toolbox

public struct NotificationsOnboardingStep: ReducerProtocol {
    public struct State: Equatable {
        public var pushOptInState: PermissionState = .unknown
    }
    
    public enum Action {
        case requestPermission
        case next
        case viewAppeared
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .next:
                return .none
                
            case .requestPermission:
                // env.permission.requestAccess { _ in }
                return .none
                
            case .viewAppeared:
                // state.pushOptInState = env.permission.status()
                return .none
            }
        }
    }
}
