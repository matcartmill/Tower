import ComposableArchitecture
import Foundation
import Permissions

public struct AvatarOnboardingStep: ReducerProtocol {
    public struct State: Equatable {
        public var permissionState: PermissionState
        
        public init(permissionState: PermissionState = .unknown) {
            self.permissionState = permissionState
        }
    }
    
    public enum Action {
        case next
        case requestPermission
        case selectPhoto
    }
    
    @Dependency (\.permissions) private var permissions
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestPermission:
                permissions.photos.requestAccess { _ in }
                
                return .none
                
            case .selectPhoto:
                switch permissions.photos.status() {
                case .unknown:
                    return .init(value: .requestPermission)
    
                case .authorized, .denied:
                    return .none
                }
                
            case .next:
                return .none
            }
        }
    }
}
