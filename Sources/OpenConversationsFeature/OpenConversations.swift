import ComposableArchitecture

public struct OpenConversations: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action { }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
