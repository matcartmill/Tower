import ComposableArchitecture
import Foundation

public typealias AppLoadingStore = Store<AppLoadingState, AppLoadingAction>
public typealias AppLoadingViewStore = ViewStore<AppLoadingState, AppLoadingAction>
public typealias AppLoadingReducer = Reducer<AppLoadingState, AppLoadingAction, AppLoadingEnvironment>

public let appLoadingReducer = AppLoadingReducer { state, action, env in
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
