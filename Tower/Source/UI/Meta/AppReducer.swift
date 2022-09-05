import ComposableArchitecture
import Foundation

public typealias AppStore = Store<AppState, AppAction>
public typealias AppViewStore = ViewStore<AppState, AppAction>
public typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>

public let appReducer = AppReducer.combine(
    authReducer.optional().pullback(
        state: \.authState,
        action: /AppAction.auth,
        environment: { _ in .live }
    ),
    homeReducer.optional().pullback(
        state: \.homeState,
        action: /AppAction.home,
        environment: { _ in .live }
    ),
    .init { state, action, env in
        switch action {
        case .dataLoaded:
            state.hasLoaded = true
            state.authState = .init()
            return .none
            
        case .viewLoaded:
            return .task {
                try! await DispatchQueue.main.sleep(for: 1)
                return .dataLoaded
            }
            
        // Bridge - Auth
            
        case .auth(.succeeded):
            guard let user = state.authState?.user else { return .none }
            
            state.authState = nil
            state.homeState = .init(
                conversations: [
                    .init(
                        conversation: .init(
                            participants: [.sender, .receiver],
                            messages: [
                               .init(
                                   content: "Hey everyone, I’ve got something on my mind that I would love to share. Please bear with me, this could get a bit lengthy.",
                                   sender: Participant.sender.id
                               ),
                               .init(
                                   content: "No worries! Feel free to vent. I’m here to listen!",
                                   sender: Participant.receiver.id
                               ),
                               .init(
                                   content: "Vent all you need.",
                                   sender: Participant.receiver.id
                               )
                            ]
                        ),
                        user: user
                    )
                ],
                user: user
            )
            
            return .none
            
        case .auth:
            return .none
            
        // Bridge - Home
            
        case .home:
            return .none
        }
    }
)
