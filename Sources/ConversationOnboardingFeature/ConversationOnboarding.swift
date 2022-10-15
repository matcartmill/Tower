import ComposableArchitecture

public struct ConversationOnboarding: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        case cancel
        case next
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
