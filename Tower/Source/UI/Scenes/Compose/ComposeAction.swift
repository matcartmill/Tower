import ComposableArchitecture

public enum ComposeAction: Equatable {
    case binding(BindingAction<ComposeState>)
    case viewLoaded
    case textFieldChanged(String)
    case start
    case cancel
}
