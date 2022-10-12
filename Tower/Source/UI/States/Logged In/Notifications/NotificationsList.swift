import ComposableArchitecture
import Foundation

public struct NotificationsList: ReducerProtocol {
    public struct State: Equatable { }
    
    public enum Action { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
