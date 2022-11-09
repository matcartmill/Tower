import AccountFeature
import ComposableArchitecture
import ComposeFeature
import ConversationFeature
import ConversationOnboardingFeature
import CoreUI
import Models
import MyConversationsFeature
import OpenConversationsFeature
import SwiftUI

public struct ConversationsView: View {
    struct TabPreference: PreferenceKey {
        static var defaultValue: [Conversations.Tab: Anchor<CGRect>] = [:]

        static func reduce(value: inout [Conversations.Tab: Anchor<CGRect>], nextValue: () -> [Conversations.Tab: Anchor<CGRect>]) {
            value.merge(nextValue(), uniquingKeysWith: { a, _ in a })
        }
    }
    
    public let store: StoreOf<Conversations>
    
    public init(store: StoreOf<Conversations>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack {
                            HStack(spacing: 18) {
                                SegmentButton(title: "Open Requests", isActive: viewStore.activeTab == .openConversations) {
                                    viewStore.send(.viewOpenRequests, animation: .spring())
                                }
                                .anchorPreference(key: TabPreference.self, value: .bounds) { [.openConversations: $0] }
                                
                                SegmentButton(title: "My Conversations", isActive: viewStore.activeTab == .myConversations) {
                                    viewStore.send(.viewMyConversations, animation: .spring())
                                }
                                .anchorPreference(key: TabPreference.self, value: .bounds) { [.myConversations: $0] }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlayPreferenceValue(TabPreference.self) { value in
                            if let value = value[viewStore.activeTab] {
                                GeometryReader { proxy in
                                    Asset.Colors.Content.primary.swiftUIColor
                                        .frame(width: 50, height: 3)
                                        .clipShape(Capsule())
                                        .offset(x: proxy[value].minX, y: proxy[value].maxY)
                                }
                            }
                        }
                        
                        switch viewStore.activeTab {
                        case .openConversations:
                            let openConversationsStore = store.scope(
                                state: \.openConversationsState,
                                action: Conversations.Action.openConversations
                            )
                            
                            OpenConversationsView(store: openConversationsStore)
                                .transition(.move(edge: .leading))
                            
                        case .myConversations:
                            let myConversationsStore = store.scope(
                                state: \.myConversationsState,
                                action: Conversations.Action.myConversations
                            )
                            
                            MyConversationsView(store: myConversationsStore)
                                .transition(.move(edge: .trailing))
                        }
                    }
                    .navigationDestination(isPresented: viewStore.binding(
                        get: { return $0.selectedConversation != nil },
                        send: Conversations.Action.dismissConversation
                    )) {
                        IfLetStore(
                            store.scope(
                                state: \.selectedConversation,
                                action: Conversations.Action.conversation
                            ),
                            then: {
                                ConversationDetailView(store: $0)
                            }
                        )
                    }
                    
                    Button(action: { viewStore.send(.openComposer) }) {
                        Asset.Icons.plus.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .padding(12)
                            .tint(Asset.Colors.Content.Button.primary.swiftUIColor)
                    }
                    .background(Asset.Colors.Background.Button.primary.swiftUIColor)
                    .clipShape(Circle())
                    .padding([.bottom, .trailing], 30)
                }
                .background(Asset.Colors.Background.base.swiftUIColor.ignoresSafeArea())
                .onAppear { viewStore.send(.viewShown) }
                .navigationBarTitle(Text("Conversations"))
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Asset.Icons.account.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Asset.Colors.Content.primary.swiftUIColor)
                                .frame(alignment: .leading)
                        }
                    }
                }
                .fullScreenCover(isPresented: viewStore.binding(
                    get: { $0.newConversation != nil },
                    send: Conversations.Action.compose(.close)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.newConversation,
                            action: Conversations.Action.compose
                        )
                    ) {
                        ComposeView(store: $0)
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.accountState != nil },
                    send: Conversations.Action.account(.close)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.accountState,
                            action: Conversations.Action.account
                        )
                    ) {
                        AccountView(store: $0)
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.conversationOnboardingState != nil },
                    send: Conversations.Action.onboarding(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.conversationOnboardingState,
                            action: Conversations.Action.onboarding
                        )
                    ) {
                        ConversationOnboardingView(store: $0)
                            .presentationDetents([.medium])
                    }
                }
            }
        }
    }
}

struct SegmentButton: View {
    let title: String
    var isActive: Bool
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(title) { action() }
                .padding(.bottom, 8)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(
                    isActive ? Asset.Colors.Content.primary.swiftUIColor : Asset.Colors.Content.secondary.swiftUIColor
                )
        }
    }
}
