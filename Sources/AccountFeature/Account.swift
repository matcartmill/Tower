import APIClient
import ComposableArchitecture
import Models
import Permissions
import Session

public struct Account: ReducerProtocol {
    public struct State: Equatable {
        @BindableState public var notificationsEnabled: Bool
        
        public init(notificationsEnabled: Bool = true) {
            self.notificationsEnabled = notificationsEnabled
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<Account.State>)
        case close
        case enablePush
        case logout
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
                
                return .fireAndForget { _ = apiClient.logout(session.jwt) }
            }
        }
        
        BindingReducer()
    }
}
