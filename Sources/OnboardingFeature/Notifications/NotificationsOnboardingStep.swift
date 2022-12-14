import ComposableArchitecture
import Foundation
import Permissions

public struct NotificationsOnboardingStep: ReducerProtocol {
    public struct State: Equatable {
        public var optInState: PermissionState
        
        public init(optInState: PermissionState = .unknown) {
            self.optInState = optInState
        }
    }
    
    public enum Action {
        case requestPermission
        case next
        case viewAppeared
    }
    
    @Dependency (\.permissions) private var permissions
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .next:
                return .none

            case .requestPermission:
                permissions.notifications.requestAccess { _ in }
                return .none

            case .viewAppeared:
                state.optInState = permissions.notifications.status()
                return .none
            }
        }
    }
}
