import ComposableArchitecture
import Foundation

struct ApplicationDelegate: ReducerProtocol {
    struct State { }
    
    enum Action {
        case didFinishLaunching
        case didRegisterForRemoteNotifications(TaskResult<Data>)
        case userNotifications(UserNotificationClient.DelegateEvent)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .didFinishLaunching:
                return .none
                
            case .didRegisterForRemoteNotifications(.success(let data)):
                return .none
                
            case .didRegisterForRemoteNotifications:
                return .none
                
            case .userNotifications:
                return .none
            }
        }
    }
}
