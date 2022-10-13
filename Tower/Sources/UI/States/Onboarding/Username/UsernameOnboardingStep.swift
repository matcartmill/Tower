import ComposableArchitecture
import Foundation

public struct UsernameOnboardingStep: ReducerProtocol {
    public struct State: Equatable { }
    
    public enum Action {
        case next
    }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}

