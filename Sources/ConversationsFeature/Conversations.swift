import APIClient
import ComposableArchitecture
import AccountFeature
import ComposeFeature
import ConversationFeature
import ConversationDisclosureFeature
import IncomingRequestsFeature
import InformationDisclosureFeature
import Models
import MyConversationsFeature
import OpenConversationsFeature
import OutgoingRequestsFeature
import Session
import SwiftUI

public struct Conversations: ReducerProtocol {
    enum Tab: Equatable {
        case openConversations
        case myConversations
    }
    
    fileprivate enum DisclosureEvent: Equatable {
        case accept(IncomingConversationRequest.ID)
        case request(Conversation.ID)
    }
    
    public struct State: Equatable {
        public var incomingRequests: IncomingRequests.State
        public var outgoingRequests: OutgoingRequests.State
        public var openConversations: OpenConversations.State
        public var activeConversations: MyConversations.State
        
        public var user: User
        public var accountState: Account.State?
        public var newConversation: Compose.State?
        public var selectedConversation: ConversationDetail.State?
        public var conversationDisclosureState: ConversationDisclosure.State?
        public var informationDisclosureState: InformationDisclosure.State?
        
        var activeTab: Tab = .openConversations
        
        fileprivate var disclosureEvent: DisclosureEvent?
        
        public init(user: User) {
            self.user = user
            self.incomingRequests = .init()
            self.outgoingRequests = .init()
            self.activeConversations = .init()
            self.openConversations = .init()
        }
    }
    
    public enum Action {
        case refresh
        
        // Account
        case openAccount
        
        // Compose
        case openComposer
        case closeComposer
        case composingFailed
        case composingSuccessful(TransmittedConversation)
        
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
        case activeConversations(MyConversations.Action)
        case conversationDisclosure(ConversationDisclosure.Action)
        case informationDisclosure(InformationDisclosure.Action)
        case openConversations(OpenConversations.Action)
        case incomingRequests(IncomingRequests.Action)
        case outgoingRequests(OutgoingRequests.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.conversationGateway) var conversationGateway
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .refresh:
                return .merge(
                    .task { .incomingRequests(.loadRequests) },
                    .task { .outgoingRequests(.loadRequests) },
                    .task { .activeConversations(.loadConversations) },
                    .task { .openConversations(.loadConversations) }
                )
                
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
                state.conversationDisclosureState = .init()
                
                return .none
                
            case .closeComposer:
                state.newConversation = nil
                
                return .none
                
            case .composingFailed:
                return .none
                
            case .composingSuccessful(let conversation):
                state.activeConversations.conversations.insert(
                    .init(
                       id: .init(conversation.id.uuidString),
                       author: conversation.author,
                       partner: conversation.participant,
                       messages: conversation.messages,
                       createdAt: conversation.createdAt,
                       updatedAt: conversation.updatedAt
                   ),
                    at: 0
                )
                
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
                    let newConversation = state.newConversation?.newConversation,
                    let jwt = sessionStore.session?.jwt
                else { return .none }
                
                return apiClient.createConversation(jwt, .init(newConversation))
                    .map { result in
                        switch result {
                        case .success(let conversation):
                            return .composingSuccessful(conversation)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            return .composingFailed
                        }
                    }
                
            case .compose(.textFieldChanged):
                return .none
                
            case .compose(.close):
                return .task { .closeComposer }
                
            // Bridges - Conversation Disclosure

            case .conversationDisclosure(.next):
                state.conversationDisclosureState = nil
                state.newConversation = .init(newConversation: .init(category: .none, content: ""))
                
                return .none
                
            case .conversationDisclosure(.cancel):
                state.conversationDisclosureState = nil
                
                return .none
            
            // Bridges - Conversation Details
                
            case .conversation(_):
                return .none
                
            // Bridges - My Conversations
                
            case .activeConversations:
                return .none
                
            // Bridges - Open Conversations
                
//            case .openConversations(.selectConversation(let id)):
//                state.disclosureEvent = .request(id)
//                state.informationDisclosureState = .init(context: .participant)
//
//                return .none
                
            case .openConversations:
                return .none
                
            // Bridges - Incoming Requests
                
            case .incomingRequests:
                return .none
                
            // Bridges - Outgoing Requests
                
            case .outgoingRequests:
                return .none
                
            // Bridges - Information Disclosure
                
            case .informationDisclosure(.next):
                return .none
                
            case .informationDisclosure(.cancel):
                state.disclosureEvent = nil
                state.informationDisclosureState = nil
                return .none
                
            }
        }
        .ifLet(\.accountState, action: /Action.account) {
            Account()
        }
        .ifLet(\.newConversation, action: /Action.compose) {
            Compose()
        }
        .ifLet(\.conversationDisclosureState, action: /Action.conversationDisclosure) {
            ConversationDisclosure()
        }
        .ifLet(\.selectedConversation, action: /Action.conversation) {
            ConversationDetail()
        }
        .ifLet(\.informationDisclosureState, action: /Action.informationDisclosure) {
            InformationDisclosure()
        }
        
        Scope(state: \.activeConversations, action: /Action.activeConversations) {
            MyConversations()
        }
        
        Scope(state: \.openConversations, action: /Action.openConversations) {
            OpenConversations()
        }
        
        Scope(state: \.incomingRequests, action: /Action.incomingRequests) {
            IncomingRequests()
        }
        
        Scope(state: \.outgoingRequests, action: /Action.outgoingRequests) {
            OutgoingRequests()
        }
    }
}
