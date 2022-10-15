import ComposableArchitecture
import Models

public struct Account: ReducerProtocol {
    public struct State: Equatable {
        public var user: User
        @BindableState public var notificationsEnabled: Bool
        
        public init(user: User, notificationsEnabled: Bool = true) {
            self.user = user
            self.notificationsEnabled = notificationsEnabled
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<Account.State>)
        case close
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding: return .none
            case .close: return .none
            }
        }
        
        BindingReducer()
    }
}
