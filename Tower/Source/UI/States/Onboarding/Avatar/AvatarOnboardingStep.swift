import ComposableArchitecture
import Foundation
import Toolbox

public struct AvatarOnboardingStep: ReducerProtocol {
    public struct State: Equatable {
        public var permissionState: PermissionState = .unknown
    }
    
    public enum Action {
        case next
        case requestPermission
        case selectPhoto
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestPermission:
                // env.permission.requestAccess { _ in }
                
                return .none
                
            case .selectPhoto:
                //            switch env.permission.status() {
                //            case .unknown:
                //                return .init(value: .requestPermission)
                //
                //            case .authorized, .denied:
                //                return .none
                //            }
                
                return .none
                
            case .next:
                return .none
            }
        }
    }
}
