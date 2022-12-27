import APIClient
import AppDelegateFeature
import AppLoadingFeature
import ComposableArchitecture
import ConversationsFeature
import Foundation
import Identity
import LoggedInFeature
import Models
import OnboardingFeature
import RemoteNotificationsClient
import Session
import SignInFeature
import SwiftUI
import UserNotificationsClient

public struct Root: ReducerProtocol {
    public enum State: Equatable {
        case loading(AppLoading.State)
        case loggedIn(Conversations.State)
        case loggedOut(SignIn.State)
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
        
        case handleSessionResponse(TaskResult<Session>)
        
        // Bridges
        case signIn(SignIn.Action)
        case conversations(Conversations.Action)
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
                state = .loggedIn(.init(user: user))
                
                return .fireAndForget {
                    await remoteNotifications.register()
                }
                
            case .showOnboardingExperience:
                state = .onboarding(.username(.init()))
                return .none
                
            case .handleSessionResponse(let response):
                switch response {
                case .success(let session):
                    if session.user.username != nil {
                        return .task { .showLoggedInExperience(session.user) }
                    } else {
                        return .task { .showOnboardingExperience(session.user) }
                    }
                    
                case .failure:
                    return .task { .showAuth }
                }
            
            // Bridge - Auth
                
            case .signIn(.signInResult(let response)):
                return .task { .handleSessionResponse(response) }
                
            case .signIn:
                return .none
                
            // Bridge - Logged In
                
            case .conversations(.account(.logout)):
                return .task { .showAuth }
                
            case .conversations:
                return .none
                
            // Bridge - Onboarding
                
            case .onboarding(.complete):
                return .init(value: .showLoggedInExperience(.sender))
                
            case .onboarding:
                return .none
                
            // Bridge - Loading
                
            case .loading(.loaded(let response)):
                return .task { .handleSessionResponse(response) }
                
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
        .ifCaseLet(/State.loggedIn, action: /Action.conversations) {
            Conversations()
        }
        .ifCaseLet(/State.loggedOut, action: /Action.signIn) {
            SignIn()
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
