import ComposableArchitecture
import DomainKit

public struct Account: ReducerProtocol {
    public struct State: Equatable {
        public var user: User
        @BindableState public var notificationsEnabled = true
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<Account.State>)
        case close
    }
    
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
