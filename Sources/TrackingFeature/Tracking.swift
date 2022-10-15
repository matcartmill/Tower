import ComposableArchitecture
import Models
import Foundation

public struct Tracking: ReducerProtocol {
    public struct State: Equatable {
        var tasks: [Task] = []
        
        public init(tasks: [Task]) {
            self.tasks = tasks
        }
    }
    
    public enum Action {
        case viewAppeared
        case openAccount
        case openCalendar
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
