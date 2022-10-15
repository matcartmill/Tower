import ComposableArchitecture
import Foundation
import SwiftUI

struct Root: ReducerProtocol {
    enum State: Equatable {
        case loading(AppLoading.State)
        case loggedIn(LoggedIn.State)
        case loggedOut(Auth.State)
        case onboarding(Onboarding.State)
    }
    
    enum Action {
        // App Delegate
        enum AppDelegateAction {
            case didFinishLaunching
            case didRegisterForRemoteNotifications(TaskResult<Data>)
            case userNotifications(UserNotificationClient.DelegateEvent)
        }
        
        case appDelegate(AppDelegateAction)
        
        // Scene Delegate
        case didChangeScenePhase(ScenePhase)
        
        // Experience
        case showAuth
        case showLoggedInExperience(User)
        case showOnboardingExperience(User)
        
        // Bridges
        case auth(Auth.Action)
        case loggedIn(LoggedIn.Action)
        case onboarding(Onboarding.Action)
        case loading(AppLoading.Action)
    }
    
    @Dependency(\.apiClient) private var apiClient
    @Dependency(\.remoteNotifications) private var remoteNotifications
    @Dependency(\.sessionStore) private var sessionStore
    @Dependency(\.userNotifications) private var userNotifications
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await event in self.userNotifications.delegate() {
                                await send(.appDelegate(.userNotifications(event)))
                            }
                        }
                    }
                }
                
            case .appDelegate(.didRegisterForRemoteNotifications(.success(let tokenData))):
                guard let session = sessionStore.session else { return .none }
                
                let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
                
                return .fireAndForget {
                    _ = apiClient.associateDeviceToken(session.jwt, token)
                }
                
            case .appDelegate(.didRegisterForRemoteNotifications):
                return .none
                
            case .appDelegate(.userNotifications):
                return .none
                
            case .showAuth:
                state = .loggedOut(.init())
                return .none
                
            case .showLoggedInExperience(let user):
                state = .loggedIn(.init(
                    conversations: .init(user: user),
                    tracking: .init(),
                    notifications: .init()
                ))
                return .none
                
            case .showOnboardingExperience:
                state = .onboarding(.username(.init()))
                return .none
                
            // Bridge - Auth
                
            case .auth(.authenticationResponse(.success(let session))):
                return .init(value: .showOnboardingExperience(session.user))
                
            case .auth:
                return .none
                
            // Bridge - Logged In
                
            case .loggedIn:
                return .none
                
            // Bridge - Onboarding
                
            case .onboarding(.complete):
                return .init(value: .showLoggedInExperience(.sender))
                
            case .onboarding:
                return .none
                
            // Bridge - Loading
                
            case .loading(.loaded):
                return .init(value: .showAuth)
                
            case .loading:
                return .none
                
            // Bridge - Scenes
                
            case .didChangeScenePhase(.active):
                return .fireAndForget {
                    let status = await userNotifications.getNotificationSettings().authorizationStatus
                    
                    guard status == .authorized || status == .provisional else { return }
                    
                    await remoteNotifications.register()
                }
                
            case .didChangeScenePhase:
                return .none
            }
        }
        .ifCaseLet(/State.loggedIn, action: /Action.loggedIn) {
            LoggedIn()
        }
        .ifCaseLet(/State.loggedOut, action: /Action.auth) {
            Auth()
                //.dependency(\.identityProvider, MockIdentityProvider())
                //.dependency(\.apiClient, .mock)
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            AppLoading()
        }
    }
}
