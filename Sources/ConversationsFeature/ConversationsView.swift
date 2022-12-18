import AccountFeature
import ComposableArchitecture
import ComposeFeature
import ConversationDisclosureFeature
import ConversationFeature
import CoreUI
import InformationDisclosureFeature
import Models
import MyConversationsFeature
import OpenConversationsFeature
import SwiftUI

public struct ConversationsView: View {
    public let store: StoreOf<Conversations>
    
    public init(store: StoreOf<Conversations>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                _ConversationsView(
                    activeTab: viewStore.activeTab,
                    incomingRequests: viewStore.incomingRequests.requests,
                    outgoingRequests: viewStore.outgoingRequests.requests,
                    openConversations: viewStore.openConversations.conversations,
                    activeConversations: viewStore.activeConversations.conversations,
                    onTabChangedToRequests: { viewStore.send(.viewOpenRequests, animation: .spring()) },
                    onTabChangedToConversations: { viewStore.send(.viewMyConversations, animation: .spring()) },
                    onOpenComposer: { viewStore.send(.openComposer) },
                    onSelectOpenConversation: { viewStore.send(.openConversationTapped($0)) },
                    onSelectActiveConversation: { viewStore.send(.selectConversation($0)) }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
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
                .sheet(isPresented: viewStore.binding(
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
                    get: { $0.conversationDisclosureState != nil },
                    send: Conversations.Action.conversationDisclosure(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.conversationDisclosureState,
                            action: Conversations.Action.conversationDisclosure
                        )
                    ) {
                        ConversationDisclosureView(store: $0)
                            .presentationDetents([.medium])
                            .dynamicTypeSize((.xSmall)...(.xxLarge))
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.informationDisclosureState != nil },
                    send: Conversations.Action.informationDisclosure(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.informationDisclosureState,
                            action: Conversations.Action.informationDisclosure
                        )
                    ) {
                        InformationDisclosureView(store: $0)
                            .presentationDetents([.medium])
                            .dynamicTypeSize((.xSmall)...(.xxLarge))
                    }
                }
                .onAppear { viewStore.send(.refresh) }
            }
        }
    }
}

private struct _ConversationsView: View {
    let activeTab: Conversations.Tab
    let incomingRequests: IdentifiedArrayOf<IncomingConversationRequest>
    let outgoingRequests: IdentifiedArrayOf<OutgoingConversationRequest>
    let openConversations: IdentifiedArrayOf<ConversationSummary>
    let activeConversations: IdentifiedArrayOf<Conversation>
    let onTabChangedToRequests: () -> Void
    let onTabChangedToConversations: () -> Void
    let onOpenComposer: () -> Void
    let onSelectOpenConversation: (Conversation.ID) -> Void
    let onSelectActiveConversation: (Conversation) -> Void
    
    var body: some View {
        List {
            Section {
                EmptyView()
            } header: {
                TabSelector(
                    selectedTab: activeTab,
                    onOpenRequestsSelected: onTabChangedToRequests,
                    onMyConversationsSelected: onTabChangedToConversations
                )
                .themedRow()
            }

            if activeTab == .openConversations {
                if !incomingRequests.isEmpty {
                    IncomingRequestsSection(requests: incomingRequests)
                        .themedRow()
                }
                
                if !outgoingRequests.isEmpty {
                    OutgoingRequestsSection(requests: outgoingRequests)
                        .themedRow()
                }
                
                OpenConversationsSection(
                    conversations: openConversations,
                    onSelectOpenConversation: onSelectOpenConversation
                )
                .themedRow()
            } else {
                ActiveConversationsSection(
                    conversations: activeConversations,
                    onSelectActiveConversation: onSelectActiveConversation
                )
                .themedRow()
            }
            
            Color.clear
                .frame(height: 100)
                .themedRow()
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .themedBackground()
        .overlay(alignment: .bottomTrailing) {
            Button(action: onOpenComposer) {
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
    }
}

private struct TabSelector: View {
    struct TabPreference: PreferenceKey {
        static var defaultValue: [Conversations.Tab: Anchor<CGRect>] = [:]

        static func reduce(value: inout [Conversations.Tab: Anchor<CGRect>], nextValue: () -> [Conversations.Tab: Anchor<CGRect>]) {
            value.merge(nextValue(), uniquingKeysWith: { a, _ in a })
        }
    }
    
    let selectedTab: Conversations.Tab
    let onOpenRequestsSelected: () -> Void
    let onMyConversationsSelected: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 18) {
                SegmentButton(title: "Open Requests", isActive: selectedTab == .openConversations) {
                    onOpenRequestsSelected()
                }
                .anchorPreference(key: TabPreference.self, value: .bounds) { [.openConversations: $0] }
                
                SegmentButton(title: "My Conversations", isActive: selectedTab == .myConversations) {
                    onMyConversationsSelected()
                }
                .anchorPreference(key: TabPreference.self, value: .bounds) { [.myConversations: $0] }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .themedBackground()
        .overlayPreferenceValue(TabPreference.self) { value in
            if let value = value[selectedTab] {
                GeometryReader { proxy in
                    Asset.Colors.Content.primary.swiftUIColor
                        .frame(width: 50, height: 3)
                        .clipShape(Capsule())
                        .offset(x: proxy[value].minX, y: proxy[value].maxY)
                }
            }
        }
    }
}

private struct IncomingRequestsSection: View {
    let requests: IdentifiedArrayOf<IncomingConversationRequest>
    
    var body: some View {
        Section(LocalizedStringKey("Incoming")) {
            ForEach(requests) {
                IncomingRequestItem(
                    userDetails: $0.userDetails,
                    acceptAction: { },
                    declineAction: { }
                )
                .padding(.vertical, 14)
            }
        }
    }
}

private struct OutgoingRequestsSection: View {
    let requests: IdentifiedArrayOf<OutgoingConversationRequest>
    
    var body: some View {
        Section(LocalizedStringKey("Outgoing")) {
            ForEach(requests) {
                OutgoingRequestItem(request: $0)
                    .padding(.vertical, 14)
            }
        }
    }
}

private struct OpenConversationsSection: View {
    let conversations: IdentifiedArrayOf<ConversationSummary>
    let onSelectOpenConversation: (Conversation.ID) -> Void
    
    var body: some View {
        Section(LocalizedStringKey("Open Conversations")) {
            ForEach(conversations) { conversation in
                OpenConversationItem(conversation: conversation)
                    .padding(.vertical, 14)
                    .onTapGesture { onSelectOpenConversation(conversation.id) }
            }
        }
    }
}

private struct ActiveConversationsSection: View {
    let conversations: IdentifiedArrayOf<Conversation>
    let onSelectActiveConversation: (Conversation) -> Void
    
    var body: some View {
        ForEach(conversations) { conversation in
            ActiveConversationItem(conversation: conversation)
                .onTapGesture { onSelectActiveConversation(conversation) }
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        _ConversationsView(
            activeTab: .openConversations,
            incomingRequests: [
                .init(
                    userDetails: .init(
                        username: User.lynn.username!,
                        avatar: User.lynn.avatarUrl,
                        rating: 4,
                        joined: Date()
                    )
                ),
                .init(
                    userDetails: .init(
                        username: User.mike.username!,
                        avatar: User.mike.avatarUrl,
                        rating: 2,
                        joined: Date()
                    )
                ),
                .init(
                    userDetails: .init(
                        username: User.sender.username!,
                        avatar: User.sender.avatarUrl,
                        rating: 5,
                        joined: Date()
                    )
                ),
            ],
            outgoingRequests: [
                .init(
                    summary: .init(
                        id: .init(),
                        summary: "Hey im not sure if anyone is listening or not but there's a lot going on that...",
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ),
                .init(
                    summary: .init(
                        id: .init(),
                        summary: "Hey im not sure if anyone is listening or not but there's a lot going on that...",
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ),
                .init(
                    summary: .init(
                        id: .init(),
                        summary: "Hey im not sure if anyone is listening or not but there's a lot going on that...",
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ),
            ],
            openConversations: [
                .init(
                    id: .init(),
                    summary: "Foo",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                .init(
                    id: .init(),
                    summary: "Foo",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                .init(
                    id: .init(),
                    summary: "Foo",
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ],
            activeConversations: [],
            onTabChangedToRequests: { },
            onTabChangedToConversations: { },
            onOpenComposer: { },
            onSelectOpenConversation: { _ in },
            onSelectActiveConversation: { _ in }
        )
        .padding()
        
        _ConversationsView(
            activeTab: .myConversations,
            incomingRequests: [],
            outgoingRequests: [],
            openConversations: [],
            activeConversations: [
                .init(
                    id: .init(),
                    author: .init(
                        username: User.lynn.username!,
                        avatar: User.lynn.avatarUrl,
                        rating: 3,
                        joined: Date()
                    ),
                    partner: .init(
                        username: User.mike.username!,
                        avatar: User.mike.avatarUrl,
                        rating: 4,
                        joined: Date()
                    ),
                    messages: [
                        .init(
                            id: .init(),
                            authorId: User.lynn.id,
                            conversationId: .init(),
                            content: "Hello, this is a test",
                            createdAt: Date()
                        )
                    ],
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ],
            onTabChangedToRequests: { },
            onTabChangedToConversations: { },
            onOpenComposer: { },
            onSelectOpenConversation: { _ in },
            onSelectActiveConversation: { _ in }
        )
        .padding()
    }
}
