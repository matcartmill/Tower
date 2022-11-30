import ComposableArchitecture
import Foundation
import Identifier
import Identity
import JWT
import Models

public struct APIClient {
    
    // Auth
    public var exchange: (_ identity: Identity) -> Effect<TaskResult<JWT>, Never>
    public var logout: (_ token: JWT) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // User
    public var me: (_ token: JWT) -> Effect<TaskResult<User>, Never>
    public var updateMe: (_ token: JWT, _ user: User) -> Effect<TaskResult<User>, Never>
    public var updateAvatar: (_ token: JWT, _ data: Data) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Conversation
    public var myConversations: (_ token: JWT) -> Effect<TaskResult<[TransmittedConversation]>, Never>
    public var openConversations: (_ token: JWT) -> Effect<TaskResult<PagedResponse<[ConversationSummary]>>, Never>
    public var createConversation: (_ token: JWT, _ request: CreateConversationRequest) -> Effect<TaskResult<TransmittedConversation>, Never>
    
    // Conversation Requests
    public var incomingConversationRequests: (_ token: JWT) -> Effect<TaskResult<[IncomingConversationRequest]>, Never>
    public var outgoingConversationRequests: (_ token: JWT) -> Effect<TaskResult<[OutgoingConversationRequest]>, Never>
    public var cancelOutgoingRequest: (_ token: JWT, _ requestId: UUID) -> Effect<TaskResult<APIResultResponse>, Never>
    public var answerIncomingRequest: (_ token: JWT, _ requestId: UUID) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Social
    public var addFriend: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    public var block: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    public var report: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Tracking
    public var trackMood: (_ token: JWT, _ emotion: Emotion) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Settings
    public var registerDeviceToken: (_ token: JWT, _ deviceToken: DeviceTokenRequest) -> Effect<TaskResult<APIResultResponse>, Never>

    public init(
        exchange: @escaping (_ identity: Identity) -> Effect<TaskResult<JWT>, Never>,
        logout: @escaping (_ token: JWT) -> Effect<TaskResult<APIResultResponse>, Never>,
        me: @escaping (_ token: JWT) -> Effect<TaskResult<User>, Never>,
        updateMe: @escaping (_ token: JWT, _ user: User) -> Effect<TaskResult<User>, Never>,
        updateAvatar: @escaping (_ token: JWT, _ data: Data) -> Effect<TaskResult<APIResultResponse>, Never>,
        myConversations: @escaping (_ token: JWT) -> Effect<TaskResult<[TransmittedConversation]>, Never>,
        openConversations: @escaping (_ token: JWT) -> Effect<TaskResult<PagedResponse<[ConversationSummary]>>, Never>,
        createConversation: @escaping (_ token: JWT, _ request: CreateConversationRequest) -> Effect<TaskResult<TransmittedConversation>, Never>,
        incomingConversationRequests: @escaping (_ token: JWT) -> Effect<TaskResult<[IncomingConversationRequest]>, Never>,
        outgoingConversationRequests: @escaping (_ token: JWT) -> Effect<TaskResult<[OutgoingConversationRequest]>, Never>,
        cancelOutgoingRequest: @escaping (_ token: JWT, _ requestId: UUID) -> Effect<TaskResult<APIResultResponse>, Never>,
        answerIncomingRequest: @escaping (_ token: JWT, _ requestId: UUID) -> Effect<TaskResult<APIResultResponse>, Never>,
        addFriend: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        block: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        report: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        trackMood: @escaping (_ token: JWT, _ emotion: Emotion) -> Effect<TaskResult<APIResultResponse>, Never>,
        registerDeviceToken: @escaping (_ token: JWT, _ deviceToken: DeviceTokenRequest) -> Effect<TaskResult<APIResultResponse>, Never>
    ) {
        self.exchange = exchange
        self.logout = logout
        self.me = me
        self.updateMe = updateMe
        self.updateAvatar = updateAvatar
        self.myConversations = myConversations
        self.openConversations = openConversations
        self.createConversation = createConversation
        self.incomingConversationRequests = incomingConversationRequests
        self.outgoingConversationRequests = outgoingConversationRequests
        self.cancelOutgoingRequest = cancelOutgoingRequest
        self.answerIncomingRequest = answerIncomingRequest
        self.addFriend = addFriend
        self.block = block
        self.report = report
        self.trackMood = trackMood
        self.registerDeviceToken = registerDeviceToken
    }
}
