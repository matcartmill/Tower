import ComposableArchitecture
import Foundation

public typealias JournalStore = Store<JournalState, JournalAction>
public typealias JournalViewStore = ViewStore<JournalState, JournalAction>
public typealias JournalReducer = Reducer<JournalState, JournalAction, JournalEnvironment>

public let journalReducer = JournalReducer { state, action, env in
    switch action {
    case .viewAppeared:
        return .none
    }
}
