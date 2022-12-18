import APIClient
import CalendarFeature
import ComposableArchitecture
import Models
import Foundation
import Session

public struct Tracking: ReducerProtocol {
    public struct State: Equatable {
        var calendarState: CalendarReducer.State?
        var tasks: [Task] = []
        var selectedEmotion: Emotion?
        
        public init(tasks: [Task]) {
            self.tasks = [
                .init(
                    title: "Daily Affirmations",
                    description: "Start your day or end your day with positivity. You are enough.",
                    optedIn: true,
                    frequency: .daily
                ),
                .init(
                    title: "Mindfulness",
                    description: "Spend 10 minutes per day focused on being calm and present.",
                    optedIn: false,
                    frequency: .daily
                ),
                .init(
                    title: "Box Breathing",
                    description: "Inhale. Hold. Exhale. Repeat. This powerful breathing technique aides in coping.",
                    optedIn: false,
                    frequency: .daily
                )
            ]
        }
    }
    
    public enum Action {
        case viewAppeared
        case openAccount
        case openCalendar
        
        case selectEmotion(Emotion)
        case confirmEmotionSelection
        
        case calendar(CalendarReducer.Action)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.sessionStore) var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .openAccount:
                return .none
                
            case .openCalendar:
                state.calendarState = .init()
                return .none
                
            case .viewAppeared:
                return .none
                
            case .calendar(.dismiss):
                state.calendarState = nil
                return .none
                
            case .selectEmotion(let emotion):
                state.selectedEmotion = emotion
                return .none
                
            case .confirmEmotionSelection:
                guard
                    let jwt = sessionStore.session?.jwt,
                    let emotion = state.selectedEmotion
                else { return .none }
                
                state.selectedEmotion = nil
                
                return .fireAndForget {
                    try await apiClient.trackMood(jwt, emotion)
                }
            }
        }
    }
}
