import ComposableArchitecture
import Foundation

public struct NotificationsList: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action { }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
