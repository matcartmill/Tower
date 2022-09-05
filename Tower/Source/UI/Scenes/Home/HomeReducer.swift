import ComposableArchitecture

public typealias HomeStore = Store<HomeState, HomeAction>
public typealias HomeViewStore = ViewStore<HomeState, HomeAction>
public typealias HomeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>

public let homeReducer = HomeReducer.combine(
    composeReducer.optional().pullback(
        state: \.newConversation,
        action: /HomeAction.compose,
        environment: { _ in .live }
    ),
    conversationReducer.optional().pullback(
        state: \.selectedConversation,
        action: /HomeAction.conversation,
        environment: { _ in .live }
    ),
    conversationReducer.forEach(
        state: \.conversations,
        action: /HomeAction.item(id:action:),
        environment: { _ in .live }
    ),
    accountReducer.optional().pullback(
        state: \.accountState,
        action: /HomeAction.account,
        environment: { _ in .live }
    ),
    .init { state, action, env in
        switch action {
        // Account
        
        case .openAccount:
            state.accountState = .init(user: state.user)
            
            return .none
        
        // Composer
        
        case .openComposer:
            state.newConversation = .init(
                conversation: .init(
                    participants: [Participant.sender],
                    messages: []
                ),
                user: state.user
            )
            
            return .none
            
        // Conversation
            
        case .openConversation(let id):
            guard let conversationState = state.conversations[id: id] else { return .none }
            
            state.selectedConversation = .init(
                conversation: conversationState.conversation,
                user: state.user
            )
            
            return .none
            
        case .dismissConversation:
            state.selectedConversation = nil
            
            return .none
            
        case .item:
            return .none
            
        // Bridges - Account
            
        case .account(.close):
            state.accountState = nil
            return .none
            
        case .account:
            return .none
            
        // Bridges - Compose
            
        case .compose(.viewLoaded):
            return .none
            
        case .compose(.binding):
            return .none
            
        case .compose(.start):
            guard let conversation = state.newConversation?.conversation else { return .none }
            
            state.conversations.insert(
                .init(conversation: conversation, user: state.user),
                at: 0)
            state.newConversation = nil
            
            return .init(value: .openConversation(id: conversation.id))
            
        case .compose(.textFieldChanged):            
            return .none
            
        case .compose(.cancel):
            state.newConversation = nil
            
            return .none
            
        // Bridges - Conversation
            
        case .conversation(.leave(let id)):
            state.conversations = state.conversations.filter { $0.id != id }
            
            return .init(value: .dismissConversation)
            
        case .conversation(.sendMessage):
            guard let conversation = state.selectedConversation else { return .none }
            
            state.conversations[id: conversation.id] = conversation
            
            return .none
            
        case .conversation:
            return .none
            
        }
    }
)
