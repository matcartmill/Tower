import APIClient
import ComposableArchitecture
import AccountFeature
import ComposeFeature
import ConversationFeature
import ConversationOnboardingFeature
import Models
import MyConversationsFeature
import OpenConversationsFeature
import Session
import SwiftUI

public struct Conversations: ReducerProtocol {
    public enum Tab: Equatable {
        case openConversations
        case myConversations
    }
    
    public struct State: Equatable {
        public var myConversationsState: MyConversations.State
        public var openConversationsState: OpenConversations.State
        public var user: User
        public var accountState: Account.State?
        public var newConversation: Compose.State?
        public var selectedConversation: ConversationDetail.State?
        public var conversationOnboardingState: ConversationOnboarding.State?
        public var activeTab: Tab = .openConversations
        
        public init(user: User) {
            self.user = user
            self.myConversationsState = .init(user: user)
            self.openConversationsState = .init()
        }
    }
    
    public enum Action {
        case viewShown
        
        // Account
        case openAccount
        
        // Compose
        case openComposer
        case closeComposer
        case composingFailed
        case composingSuccessful(Conversation.ID)
        
        // Conversation Detail
        case dismissConversation
        case openConversation(ConversationDetail.State)
        
        // Open Requests
        case viewOpenRequests
        
        // My Conversations
        case viewMyConversations
        
        // Bridges
        case account(Account.Action)
        case compose(Compose.Action)
        case conversation(ConversationDetail.Action)
        case myConversations(MyConversations.Action)
        case onboarding(ConversationOnboarding.Action)
        case openConversations(OpenConversations.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.conversationGateway) var conversationGateway
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewShown:
                return .none
                
            case .viewMyConversations:
                state.activeTab = .myConversations
                return .none
                
            case .viewOpenRequests:
                state.activeTab = .openConversations
                return .none
                
            // Account
            
            case .openAccount:
                state.accountState = .init()
                
                return .none
            
            // Composer
            
            case .openComposer:
                state.conversationOnboardingState = .init()
                
                return .none
                
            case .closeComposer:
                state.newConversation = nil
                
                return .none
                
            case .composingFailed:
                return .none
                
            case .composingSuccessful(let id):
                return .merge(
                    .task { .closeComposer }
                )
                
            // Conversation Detail
                
            case .openConversation(let conversationState):
                state.selectedConversation = conversationState
                return .none
                
            case .dismissConversation:
                state.selectedConversation = nil
                return .none
                
            // Bridges - Account
                
            case .account(.close):
                state.accountState = nil
                return .none
                
            case .account:
                return .none
                
            // Bridges - Compose
                
            case .compose(.start):
                guard
                    let conversation = state.newConversation?.conversation,
                    let message = conversation.messages.first?.content,
                    let jwt = sessionStore.session?.jwt
                else { return .none }
                
                return apiClient.createConversation(jwt, .init(message: .init(content: message)))
                    .map { result in
                        switch result {
                        case .success(let response) where response.success:
                            return .composingSuccessful(conversation.id)
                            
                        case .success(let response):
                            print(response.error ?? "Something went wrong...")
                            return .composingFailed
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            return .composingFailed
                        }
                    }
                
            case .compose(.textFieldChanged):
                return .none
                
            case .compose(.close):
                return .task { .closeComposer }
                
            // Bridges - Conversation Onboarding

            case .onboarding(.next):
                state.conversationOnboardingState = nil
                state.newConversation = .init(
                    conversation: .init(
                        id: .init(),
                        authorId: User.sender.id,
                        partnerId: nil,
                        messages: []
                    ),
                    user: state.user
                )
                
                return .none
                
            case .onboarding(.cancel):
                state.conversationOnboardingState = nil
                
                return .none
            
            // Bridges - Conversation Details
                
            case .conversation(_):
                return .none
                
            // Bridges - My Conversations
                
            case .myConversations(.selectedConversation(let conversationState)):
                return .task { .openConversation(conversationState) }
                
            case .myConversations:
                return .none
                
            // Bridges - Open Conversations
                
            case .openConversations:
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
        
        Scope(state: \.myConversationsState, action: /Action.myConversations) {
            MyConversations()
        }
        
        Scope(state: \.openConversationsState, action: /Action.openConversations) {
            OpenConversations()
        }
    }
}
