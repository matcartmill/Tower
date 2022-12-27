import Core
import Foundation
import Identity
import JWT
import Models

public struct APIClient {
    // Auth
    public var exchange: @Sendable (_ identity: Identity) async throws -> AuthenticationResponse
    public var refresh: @Sendable (_ request: RefreshRequest) async throws -> AuthenticationResponse
    public var logout: @Sendable (_ token: AccessToken) async throws -> Void
    
    // User
    public var me: @Sendable (_ token: AccessToken) async throws -> User
    public var updateMe: @Sendable (_ token: AccessToken, _ user: User) async throws -> User
    public var updateAvatar: @Sendable (_ token: AccessToken, _ data: Data) async throws -> Void
    
    // Conversation
    public var myConversations: @Sendable (_ token: AccessToken) async throws -> [TransmittedConversation]
    public var openConversations: @Sendable (
        _ token: AccessToken,
        _ pageInfo: PageInfo
    ) async throws -> PagedResponse<[ConversationSummary]>
    public var createConversation: @Sendable (
        _ token: AccessToken,
        _ request: CreateConversationRequest
    ) async throws -> TransmittedConversation
    
    // Messages
    public var sendMessage: @Sendable (
        _ token: AccessToken,
        _ message: String,
        _ conversationId: Identifier<Conversation>
    ) async throws -> Void
    
    // Conversation Requests
    public var incomingConversationRequests: @Sendable (_ token: AccessToken) async throws -> [IncomingConversationRequest]
    public var outgoingConversationRequests: @Sendable (_ token: AccessToken) async throws -> [OutgoingConversationRequest]
    public var sendOutgoingRequest: @Sendable (_ token: AccessToken, _ id: Conversation.ID) async throws -> OutgoingConversationRequest
    public var cancelOutgoingRequest: @Sendable (_ token: AccessToken, _ requestId: Identifier<OutgoingConversationRequest>) async throws -> Void
    public var answerIncomingRequest: @Sendable (_ token: AccessToken, _ requestId: Identifier<IncomingConversationRequest>) async throws -> Void
    
    // Social
    public var addFriend: @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void
    public var block: @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void
    public var report: @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void
    
    // Tracking
    public var trackMood: @Sendable (_ token: AccessToken, _ emotion: Emotion) async throws -> Void
    
    // Settings
    public var registerDeviceToken: @Sendable (_ token: AccessToken, _ deviceToken: DeviceTokenRequest) async throws -> Void

    public init(
        exchange: @escaping @Sendable (_ identity: Identity) async throws -> AuthenticationResponse,
        refresh: @escaping @Sendable (_ request: RefreshRequest) async throws -> AuthenticationResponse,
        logout: @escaping @Sendable (_ token: AccessToken) async throws -> Void,
        me: @escaping @Sendable (_ token: AccessToken) async throws -> User,
        updateMe: @escaping @Sendable (_ token: AccessToken, _ user: User) async throws -> User,
        updateAvatar: @escaping @Sendable (_ token: AccessToken, _ data: Data) async throws -> Void,
        myConversations: @escaping @Sendable (_ token: AccessToken) async throws -> [TransmittedConversation],
        openConversations: @escaping @Sendable (
            _ token: AccessToken,
            _ pageInfo: PageInfo
        ) async throws -> PagedResponse<[ConversationSummary]>,
        createConversation: @escaping @Sendable (
            _ token: AccessToken,
            _ request: CreateConversationRequest
        ) async throws -> TransmittedConversation,
        sendMessage: @escaping @Sendable (
            _ token: AccessToken,
            _ message: String, _ conversationId: Identifier<Conversation>
        ) async throws -> Void,
        incomingConversationRequests: @escaping @Sendable (_ token: AccessToken) async throws -> [IncomingConversationRequest],
        outgoingConversationRequests: @escaping @Sendable (_ token: AccessToken) async throws -> [OutgoingConversationRequest],
        sendOutgoingRequest: @escaping @Sendable (_ token: AccessToken, _ id: Conversation.ID) async throws -> OutgoingConversationRequest,
        cancelOutgoingRequest: @escaping @Sendable (_ token: AccessToken, _ requestId: Identifier<OutgoingConversationRequest>) async throws -> Void,
        answerIncomingRequest: @escaping @Sendable (_ token: AccessToken, _ requestId: Identifier<IncomingConversationRequest>) async throws -> Void,
        addFriend: @escaping @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void,
        block: @escaping @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void,
        report: @escaping @Sendable (_ token: AccessToken, _ user: Identifier<User>) async throws -> Void,
        trackMood: @escaping @Sendable (_ token: AccessToken, _ emotion: Emotion) async throws -> Void,
        registerDeviceToken: @escaping @Sendable (_ token: AccessToken, _ deviceToken: DeviceTokenRequest) async throws -> Void
    ) {
        self.exchange = exchange
        self.refresh = refresh
        self.logout = logout
        self.me = me
        self.updateMe = updateMe
        self.updateAvatar = updateAvatar
        self.myConversations = myConversations
        self.openConversations = openConversations
        self.createConversation = createConversation
        self.sendMessage = sendMessage
        self.incomingConversationRequests = incomingConversationRequests
        self.outgoingConversationRequests = outgoingConversationRequests
        self.sendOutgoingRequest = sendOutgoingRequest
        self.cancelOutgoingRequest = cancelOutgoingRequest
        self.answerIncomingRequest = answerIncomingRequest
        self.addFriend = addFriend
        self.block = block
        self.report = report
        self.trackMood = trackMood
        self.registerDeviceToken = registerDeviceToken
    }
}
