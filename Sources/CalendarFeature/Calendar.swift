import ComposableArchitecture

public struct CalendarReducer: ReducerProtocol {
    public struct State: Equatable {
        public let dataSource = CalendarDataSource()
        
        public init() { }
    }
    public enum Action {
        case dismiss
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}
