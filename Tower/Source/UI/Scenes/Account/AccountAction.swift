import ComposableArchitecture

public enum AccountAction: BindableAction {
    case close
    case binding(BindingAction<AccountState>)
}
