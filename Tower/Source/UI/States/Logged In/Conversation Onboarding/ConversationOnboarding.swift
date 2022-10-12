import ComposableArchitecture

public struct ConversationOnboarding: ReducerProtocol {
    public struct State: Equatable { }
    
    public enum Action {
        case cancel
        case next
    }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
