import APIClient
import ComposableArchitecture
import Foundation
import Session
import UserNotificationsClient

public struct ApplicationDelegate: ReducerProtocol {
    public typealias State = Void
    
    public enum Action {
        case nothing
        case didFinishLaunching
        case didRegisterForRemoteNotifications(TaskResult<Data>)
        case userNotifications(UserNotificationClient.DelegateEvent)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.sessionStore) private var sessionStore
    @Dependency(\.userNotifications) private var userNotifications
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .nothing:
                return .none
                
            case .didFinishLaunching:
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await event in self.userNotifications.delegate() {
                                await send(.userNotifications(event))
                            }
                        }
                    }
                }
                
            case .didRegisterForRemoteNotifications(.success(let tokenData)):
                guard let session = sessionStore.session else { return .none }
                
                let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
                
                return apiClient.registerDeviceToken(
                    session.jwt,
                    .init(token: token)
                )
                .map {
                    switch $0 {
                    case .success(let response):
                        print(response.success)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    return .nothing
                }
                
            case .didRegisterForRemoteNotifications(.failure(let error)):
                print(error)
                return .none
                
            case .userNotifications:
                return .none
            }
        }
    }
}
