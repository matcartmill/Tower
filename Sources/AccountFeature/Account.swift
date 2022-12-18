import APIClient
import ComposableArchitecture
import ImageUploaderFeature
import Models
import Permissions
import Session

public struct Account: ReducerProtocol {
    public struct State: Equatable {
        @BindableState var notificationsEnabled: Bool
        var user: User
        var imageUploaderState: ImageUploader.State = .init()
        
        public init(user: User, notificationsEnabled: Bool = true) {
            self.user = user
            self.notificationsEnabled = notificationsEnabled
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<Account.State>)
        case close
        case enablePush
        case logout
        case updateAvatarButtonTapped
        case avatarUploaderDismissed
        
        case imageUploader(ImageUploader.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.permissions) private var permissions
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .close:
                return .none
                
            case .enablePush:
                return .fireAndForget {
                    permissions.notifications.requestAccess { _ in }
                }
                
            case .logout:
                guard let session = sessionStore.session else { return .none }
                
                return .fireAndForget {
                    try await apiClient.logout(session.jwt)
                }
                
            case .updateAvatarButtonTapped:
                state.imageUploaderState = .init()
                return .none
                
            case .avatarUploaderDismissed:
                return .none
                
            // Bridges - Image Uploader
                
            case .imageUploader:
                return .none
            }
        }
        
        BindingReducer()
    }
}
