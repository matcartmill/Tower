import ComposableArchitecture

public typealias AccountStore = Store<AccountState, AccountAction>
public typealias AccountViewStore = ViewStore<AccountState, AccountAction>
public typealias AccountReducer = Reducer<AccountState, AccountAction, AccountEnvironment>

public let accountReducer = AccountReducer { state, action, env in
    switch action {
    case .close:
        return .none
        
    case .binding:
        return .none
    }
}
.binding()
