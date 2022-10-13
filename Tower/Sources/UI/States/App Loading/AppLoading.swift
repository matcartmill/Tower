import ComposableArchitecture
import Foundation

public struct AppLoading: ReducerProtocol {
    public struct State: Equatable {}
    
    public enum Action {
        case load
        case loaded
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .load:
            return .task {
                try! await DispatchQueue.main.sleep(for: 1)
                return .loaded
            }
            
        case .loaded:
            return .none
        }
    }
}
