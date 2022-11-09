import APIClient
import AppDelegateFeature
import AppLoadingFeature
import AuthFeature
import ComposableArchitecture
import Foundation
import Identity
import LoggedInFeature
import Models
import OnboardingFeature
import RemoteNotificationsClient
import Session
import SwiftUI
import UserNotificationsClient

public struct Root: ReducerProtocol {
    public enum State: Equatable {
        case loading(AppLoading.State)
        case loggedIn(LoggedIn.State)
        case loggedOut(Auth.State)
        case onboarding(Onboarding.State)
    }
    
    public enum Action {
        // App Delegate
        case appDelegate(ApplicationDelegate.Action)
        
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
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.appDelegate, action: /Action.appDelegate) {
            ApplicationDelegate()
        }
        
        Reduce { state, action in
            switch action {
            case .appDelegate(.didRegisterForRemoteNotifications(let result)):
                print(result)
                return .none
                
            case .appDelegate:
                return .none
                
            case .showAuth:
                state = .loggedOut(.init())
                return .none
                
            case .showLoggedInExperience(let user):
                state = .loggedIn(.init(
                    conversations: .init(user: user),
                    tracking: .init(tasks: []),
                    notifications: .init()
                ))
                return .fireAndForget {
                    await remoteNotifications.register()
                }
                
            case .showOnboardingExperience:
                state = .onboarding(.username(.init()))
                return .none
                
            // Bridge - Auth
                
            case .auth(.authenticationResponse(.success(let session))):
                if session.user.username != nil {
                    return .init(value: .showLoggedInExperience(session.user))
                } else {
                    return .init(value: .showOnboardingExperience(session.user))
                }
                
            case .auth:
                return .none
                
            // Bridge - Logged In
                
            case .loggedIn(.conversations(.account(.logout))):
                return .task { .showAuth }
                
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
//                .dependency(\.identityProvider, MockIdentityProvider())
//                .dependency(\.apiClient, .mock)
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            AppLoading()
        }
    }
}

extension Root.State {
    public var appDelegate: Void {
        get { () }
        set { }
    }
}
