import ComposableArchitecture
import SwiftUI
import DomainKit

public typealias ConversationsStore = Store<ConversationsState, ConversationsAction>
public typealias ConversationsViewStore = ViewStore<ConversationsState, ConversationsAction>
public typealias ConversationsReducer = Reducer<ConversationsState, ConversationsAction, ConversationsEnvironment>

public let conversationsReducer = ConversationsReducer.combine(
    composeReducer.optional().pullback(
        state: \.newConversation,
        action: /ConversationsAction.compose,
        environment: { _ in .live }
    ),
    conversationOnboardingReducer.optional().pullback(
        state: \.conversationOnboardingState,
        action: /ConversationsAction.onboarding,
        environment: { _ in .init() }
    ),
    conversationReducer.optional().pullback(
        state: \.selectedConversation,
        action: /ConversationsAction.conversation,
        environment: { _ in .live }
    ),
    conversationReducer.forEach(
        state: \.conversations,
        action: /ConversationsAction.item(id:action:),
        environment: { _ in .live }
    ),
    accountReducer.optional().pullback(
        state: \.accountState,
        action: /ConversationsAction.account,
        environment: { _ in .live }
    ),
    .init { state, action, env in
        switch action {
        case .viewShown:
            state.conversations = [
                .init(
                    conversation: .init(
                        author: .sender,
                        participant: .receiver,
                        messages: [
                           .init(
                               content: "Hey everyone, I’ve got something on my mind that I would love to share. Please bear with me, this could get a bit lengthy.",
                               sender: User.sender
                           ),
                           .init(
                               content: "No worries! Feel free to vent. I’m here to listen!",
                               sender: User.receiver
                           ),
                           .init(
                               content: "Vent all you need.",
                               sender: User.receiver
                           )
                        ]
                    ),
                    user: state.user
                )
            ]
            
            return .none
            
        // Account
        
        case .openAccount:
            state.accountState = .init(user: state.user)
            
            return .none
        
        // Composer
        
        case .openComposer:
            state.conversationOnboardingState = .init()
            
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
            
        // Notifications
            
        case .openNotifications:
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
            
        // Bridges - Conversation Onboarding

        case .onboarding(.select):
            state.conversationOnboardingState = nil
            state.newConversation = .init(
                conversation: .init(
                    author: .sender,
                    participant: nil,
                    messages: []
                ),
                user: state.user
            )
            
            return .none
            
        case .onboarding(.cancel):
            state.conversationOnboardingState = nil
            
            return .none
        }
    }
)
