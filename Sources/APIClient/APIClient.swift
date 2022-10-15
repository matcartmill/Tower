import ComposableArchitecture
import Foundation
import Identifier
import Identity
import JWT
import Models

public struct APIClient {
    // Auth
    public var exchange: (_ identity: Identity) -> Effect<TaskResult<JWT>, Never>
    
    // User
    public var me: (_ token: JWT) -> Effect<TaskResult<User>, Never>
    public var updateMe: (_ token: JWT, _ user: User) -> Effect<TaskResult<User>, Never>
    public var updateAvatar: (_ token: JWT, _ data: Data) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Social
    public var addFriend: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    public var block: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    public var report: (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>
    
    // Settings
    public var associateDeviceToken: (_ token: JWT, _ deviceToken: String) -> Effect<TaskResult<APIResultResponse>, Never>

    public init(
        exchange: @escaping (_ identity: Identity) -> Effect<TaskResult<JWT>, Never>,
        me: @escaping (_ token: JWT) -> Effect<TaskResult<User>, Never>,
        updateMe: @escaping (_ token: JWT, _ user: User) -> Effect<TaskResult<User>, Never>,
        updateAvatar: @escaping (_ token: JWT, _ data: Data) -> Effect<TaskResult<APIResultResponse>, Never>,
        addFriend: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        block: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        report: @escaping (_ token: JWT, _ user: Identifier<User>) -> Effect<TaskResult<APIResultResponse>, Never>,
        associateDeviceToken: @escaping (_ token: JWT, _ deviceToken: String) -> Effect<TaskResult<APIResultResponse>, Never>
    ) {
        self.exchange = exchange
        self.me = me
        self.updateMe = updateMe
        self.updateAvatar = updateAvatar
        self.addFriend = addFriend
        self.block = block
        self.report = report
        self.associateDeviceToken = associateDeviceToken
    }
}
