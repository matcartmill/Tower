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
        var isComposing = false
        
        fileprivate var disclosureEvent: DisclosureEvent?
        fileprivate var hasOpenedSocketConnections = false
        
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
        
        // Sockets
        case openSockets
        case closeSockets
        
        // Account
        case openAccount
        
        // Compose
        case openComposer
        case closeComposer
        case composingFailed
        case composingSuccessful(TransmittedConversation)
        
        // Conversation Detail
        case selectConversation(Conversation)
        case dismissConversation
        case viewConversation(ConversationDetail.State)
        
        // Conversation Disclosure
        case conversationDisclosureDismissed
        case cancelConversationDisclosure
        
        // Information Disclosure
        case cancelInformationDisclosure
        
        // Incoming Requests
        case acceptIncomingRequest(IncomingConversationRequest.ID)
        case declineIncomingRequest(IncomingConversationRequest.ID)
        
        // Outgoing Requests
        case cancelOutgoingRequest(OutgoingConversationRequest.ID)
        
        // Open Requests
        case viewOpenRequests
        case openConversationTapped(Conversation.ID)
        case loadMoreOpenConversations
        
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
    @Dependency(\.sessionStore) private var sessionStore
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
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
        
        Reduce { state, action in
            switch action {
            case .refresh:
                return .merge(
                    .task { .incomingRequests(.loadRequests) },
                    .task { .outgoingRequests(.loadRequests) },
                    .task { .activeConversations(.loadConversations) },
                    .task { .openConversations(.loadConversations) }
                )
                
            case .openSockets:
                guard !state.hasOpenedSocketConnections else { return .none }
                
                state.hasOpenedSocketConnections = true
                
                return .merge(
                    .task { .incomingRequests(.openWebSocket) },
                    .task { .openConversations(.openWebSocket) },
                    .task { .activeConversations(.openWebSocket) }
                )
                
            case .closeSockets:
                guard state.hasOpenedSocketConnections else { return .none }
                
                state.hasOpenedSocketConnections = false
                
                return .merge(
                    .task { .incomingRequests(.closeWebSocket) },
                    .task { .openConversations(.closeWebSocket) },
                    .task { .activeConversations(.closeWebSocket) }
                )
                
            case .viewMyConversations:
                state.activeTab = .myConversations
                return .none
                
            // Incoming Requests
            case .acceptIncomingRequest(let id):
                state.disclosureEvent = .accept(id)
                state.informationDisclosureState = .init(context: .author)
                
                return .none
                
            case .declineIncomingRequest(let id):
                return .task { .incomingRequests(.decline(id)) }
                
            // Outgoing Requests
            case .cancelOutgoingRequest(let id):
                return .task { .outgoingRequests(.cancel(id)) }
                
            // Open Conversations
                
            case .viewOpenRequests:
                state.activeTab = .openConversations
                return .none
                
            case .openConversationTapped(let id):
                state.disclosureEvent = .request(id)
                state.informationDisclosureState = .init(context: .participant)
                
                return .none
                
            case .loadMoreOpenConversations:
                return .task { .openConversations(.loadConversations) }
                
            // Account
            
            case .openAccount:
                state.accountState = .init(user: state.user)
                return .none
            
            // Composer
            
            case .openComposer:
                state.conversationDisclosureState = .init()
                
                return .none
                
            case .closeComposer:
                state.newConversation = nil
                state.isComposing = false
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
                
            // Conversation Disclosure
            case .cancelConversationDisclosure:
                state.conversationDisclosureState = nil
                return .none
                
            case .conversationDisclosureDismissed:
                state.isComposing = state.newConversation != nil
                return .none
                
            // Information Disclosure
            case .cancelInformationDisclosure:
                state.disclosureEvent = nil
                state.informationDisclosureState = nil
                
                return .none
                
            // Conversation Detail
            case .selectConversation(let conversation):
                let conversationState = ConversationDetail.State(conversation: conversation, user: state.user)
                state.selectedConversation = conversationState
                
                return .none
                
            case .viewConversation(let conversationState):
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
                    let accessToken = sessionStore.session?.accessToken
                else { return .none }
                
                return .task {
                    do {
                        let conversation = try await apiClient.createConversation(accessToken, .init(newConversation))
                        return .composingSuccessful(conversation)
                    } catch let error {
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
                return .task { .cancelConversationDisclosure }
            
            // Bridges - Conversation Details
                
            case .conversation(_):
                return .none
                
            // Bridges - My Conversations
                
            case .activeConversations:
                return .none
                
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
                guard
                    let accessToken = sessionStore.session?.accessToken,
                    let event = state.disclosureEvent,
                    case let .request(conversationId) = event
                else { return .none }
                
                state.disclosureEvent = nil
                state.informationDisclosureState = nil
                
            return .merge(
                .task { .openConversations(.removeExistingSummary(conversationId)) },
                .task {
                    let request = try await apiClient.sendOutgoingRequest(accessToken, conversationId)
                    return .outgoingRequests(.addRequest(request))
                }
            )
                
            case .informationDisclosure(.cancel):
                return .task { .cancelInformationDisclosure }
                
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
    }
}
