import ComposableArchitecture
import SwiftUI

public struct Conversations: ReducerProtocol {
    public struct State: Equatable {
        public var conversations: IdentifiedArrayOf<ConversationDetail.State> = []
        public var user: User
        public var accountState: Account.State?
        public var newConversation: Compose.State?
        public var selectedConversation: ConversationDetail.State?
        public var conversationOnboardingState: ConversationOnboarding.State?
    }
    
    public enum Action {
        case viewShown
        
        // Account
        case openAccount
        
        // Compose
        case openComposer
        case closeComposer
        
        // Notifications
        case openNotifications
        
        // Details
        case openConversation(id: Conversation.ID)
        case dismissConversation
        case item(id: Conversation.ID, action: ConversationDetail.Action)
        
        // Bridges
        case account(Account.Action)
        case compose(Compose.Action)
        case conversation(ConversationDetail.Action)
        case onboarding(ConversationOnboarding.Action)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
                
            case .closeComposer:
                state.newConversation = nil
                
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
                
            case .compose(.start):
                guard let conversation = state.newConversation?.conversation else { return .none }
                
                state.conversations.insert(
                    .init(conversation: conversation, user: state.user),
                    at: 0)
                
                return .merge(
                    .task { .closeComposer },
                    .task { .openConversation(id: conversation.id) }
                )
                
            case .compose(.textFieldChanged):
                return .none
                
            case .compose(.close):
                return .task { .closeComposer }
                
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

            case .onboarding(.next):
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
        .ifLet(\.accountState, action: /Action.account) {
            Account()
        }
        .ifLet(\.newConversation, action: /Action.compose) {
            Compose()
        }
        .ifLet(\.conversationOnboardingState, action: /Action.onboarding) {
            ConversationOnboarding()
        }
        .ifLet(\.selectedConversation, action: /Action.conversation) {
            ConversationDetail()
        }
        .forEach(\.conversations, action: /Action.item(id:action:)) {
            ConversationDetail()
        }
    }
}
