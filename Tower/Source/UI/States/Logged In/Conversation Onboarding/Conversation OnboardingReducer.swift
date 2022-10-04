import ComposableArchitecture

public typealias ConversationOnboardingStore = Store<ConversationOnboardingState, ConversationOnboardingAction>
public typealias ConversationOnboardingViewStore = ViewStore<ConversationOnboardingState, ConversationOnboardingAction>
public typealias ConversationOnboardingReducer = Reducer<ConversationOnboardingState, ConversationOnboardingAction, ConversationOnboardingEnvironment>

public let conversationOnboardingReducer = ConversationOnboardingReducer { state, action, env in
    switch action {
    case .cancel:
        return .none
        
    case .select:
        return .none
    }
}
