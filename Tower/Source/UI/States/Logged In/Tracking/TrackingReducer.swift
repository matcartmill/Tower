import ComposableArchitecture
import Foundation

public typealias TrackingStore = Store<TrackingState, TrackingAction>
public typealias TrackingViewStore = ViewStore<TrackingState, TrackingAction>
public typealias TrackingReducer = Reducer<TrackingState, TrackingAction, TrackingEnvironment>

public let trackingReducer = TrackingReducer { state, action, env in
    switch action {
    case .viewAppeared:
        return .none
        
    case .openAccount:
        return .none
        
    case .openCalendar:
        return .none
    }
}
