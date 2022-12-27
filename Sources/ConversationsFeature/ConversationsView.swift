import AccountFeature
import ComposableArchitecture
import ComposeFeature
import ConversationDisclosureFeature
import ConversationFeature
import Core
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
                    canLoadMoreOpenConversations: viewStore.openConversations.canLoadMoreConversations,
                    onTabChangedToRequests: { viewStore.send(.viewOpenRequests, animation: .spring()) },
                    onTabChangedToConversations: { viewStore.send(.viewMyConversations, animation: .spring()) },
                    onOpenComposer: { viewStore.send(.openComposer) },
                    onSelectOpenConversation: { viewStore.send(.openConversationTapped($0)) },
                    onSelectActiveConversation: { viewStore.send(.selectConversation($0)) },
                    onIncomingRequestAccept: { viewStore.send(.acceptIncomingRequest($0)) },
                    onIncomingRequestDecline: { viewStore.send(.declineIncomingRequest($0)) },
                    onOutgoingRequestDelete: { viewStore.send(.cancelOutgoingRequest($0)) },
                    onOpenConversationsShowMore: { viewStore.send(.loadMoreOpenConversations) },
                    onRefresh: { viewStore.send(.refresh) }
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
                .fullScreenCover(isPresented: viewStore.binding(
                    get: \.isComposing,
                    send: .closeComposer
                )) {
                    IfLetStore(
                        store.scope(
                            state: lastNonNil(\.newConversation),
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
                            state: lastNonNil(\.accountState),
                            action: Conversations.Action.account
                        )
                    ) {
                        AccountView(store: $0)
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: { $0.conversationDisclosureState != nil },
                        send: .cancelConversationDisclosure
                    ),
                    onDismiss: { viewStore.send(.conversationDisclosureDismissed) }
                ) {
                    IfLetStore(
                        store.scope(
                            state: lastNonNil(\.conversationDisclosureState),
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
                    send: Conversations.Action.cancelInformationDisclosure
                )) {
                    IfLetStore(
                        store.scope(
                            state: lastNonNil(\.informationDisclosureState),
                            action: Conversations.Action.informationDisclosure
                        )
                    ) {
                        InformationDisclosureView(store: $0)
                            .presentationDetents([.medium])
                            .dynamicTypeSize((.xSmall)...(.xxLarge))
                    }
                }
                .onAppear {
                    viewStore.send(.openSockets)
                    viewStore.send(.refresh)
                }
                .onDisappear { viewStore.send(.closeSockets) }
            }
        }
    }
}

private struct _ConversationsView: View, Equatable {
    let activeTab: Conversations.Tab
    let incomingRequests: IdentifiedArrayOf<IncomingConversationRequest>
    let outgoingRequests: IdentifiedArrayOf<OutgoingConversationRequest>
    let openConversations: IdentifiedArrayOf<ConversationSummary>
    let activeConversations: IdentifiedArrayOf<Conversation>
    let canLoadMoreOpenConversations: Bool
    let onTabChangedToRequests: () -> Void
    let onTabChangedToConversations: () -> Void
    let onOpenComposer: () -> Void
    let onSelectOpenConversation: (Conversation.ID) -> Void
    let onSelectActiveConversation: (Conversation) -> Void
    let onIncomingRequestAccept: (IncomingConversationRequest.ID) -> Void
    let onIncomingRequestDecline: (IncomingConversationRequest.ID) -> Void
    let onOutgoingRequestDelete: (OutgoingConversationRequest.ID) -> Void
    let onOpenConversationsShowMore: () -> Void
    let onRefresh: () -> Void
    
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
                .padding(.top)
                .padding(.bottom, 4)
            }
            .textCase(nil)

            if activeTab == .openConversations {
                if !incomingRequests.isEmpty {
                    IncomingRequestsSection(
                        requests: incomingRequests,
                        onAccept: { id in
                            onIncomingRequestAccept(id)
                        },
                        onDecline: { id in
                            onIncomingRequestDecline(id)
                        }
                    )
                    .themedRow()
                }
                
                if !outgoingRequests.isEmpty {
                    OutgoingRequestsSection(
                        requests: outgoingRequests,
                        onDelete: { requestId in
                            onOutgoingRequestDelete(requestId)
                        }
                    )
                    .themedRow()
                }
                
                OpenConversationsSection(
                    conversations: openConversations,
                    showMoreButton: canLoadMoreOpenConversations,
                    onSelectOpenConversation: onSelectOpenConversation,
                    onShowMore: onOpenConversationsShowMore
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
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .refreshable { onRefresh() }
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
    
    static func == (lhs: _ConversationsView, rhs: _ConversationsView) -> Bool {
        return lhs.activeTab == rhs.activeTab
        && lhs.incomingRequests == rhs.incomingRequests
        && lhs.outgoingRequests == rhs.outgoingRequests
        && lhs.openConversations == rhs.openConversations
        && lhs.activeConversations == rhs.activeConversations
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
                SegmentButton(title: "Requests", isActive: selectedTab == .openConversations) {
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
    let onAccept: (IncomingConversationRequest.ID) -> Void
    let onDecline: (IncomingConversationRequest.ID) -> Void
    
    var body: some View {
        Section {
            ForEach(requests) { request in
                IncomingRequestItem(
                    userDetails: request.user,
                    acceptAction: { onAccept(request.id) },
                    declineAction: { onDecline(request.id) }
                )
                .padding(.vertical, 14)
            }
        } header: {
            Text("Incoming Requests")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                .textCase(nil)
        } footer: {
            Color.clear
                .frame(height: 14)
        }
    }
}

private struct OutgoingRequestsSection: View {
    let requests: IdentifiedArrayOf<OutgoingConversationRequest>
    let onDelete: (OutgoingConversationRequest.ID) -> Void
    
    var body: some View {
        Section {
            ForEach(requests) { request in
                OutgoingRequestItem(
                    request: request,
                    onDelete: { onDelete(request.id) }
                )
                .padding(.vertical, 14)
            }
        } header: {
            Text("Outgoing Requests")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                .textCase(nil)
        } footer: {
            Color.clear
                .frame(height: 14)
        }
    }
}

private struct OpenConversationsSection: View {
    let conversations: IdentifiedArrayOf<ConversationSummary>
    let showMoreButton: Bool
    let onSelectOpenConversation: (Conversation.ID) -> Void
    let onShowMore: () -> Void
    
    var body: some View {
        Section {
            ForEach(conversations) { conversation in
                OpenConversationItem(conversation: conversation)
                    .padding(.vertical, 14)
                    .onTapGesture { onSelectOpenConversation(conversation.id) }
            }
        } header: {
            Text("Open Conversations")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                .textCase(nil)
        } footer: {
            if showMoreButton {
                Button("Show More") { onShowMore() }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top)
            } else {
                EmptyView()
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
                    user: .init(
                        username: User.lynn.username!,
                        avatar: User.lynn.avatarUrl,
                        rating: 4,
                        joined: Date()
                    )
                ),
                .init(
                    user: .init(
                        username: User.mike.username!,
                        avatar: User.mike.avatarUrl,
                        rating: 2,
                        joined: Date()
                    )
                ),
                .init(
                    user: .init(
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
            canLoadMoreOpenConversations: true,
            onTabChangedToRequests: { },
            onTabChangedToConversations: { },
            onOpenComposer: { },
            onSelectOpenConversation: { _ in },
            onSelectActiveConversation: { _ in },
            onIncomingRequestAccept: { _ in },
            onIncomingRequestDecline: { _ in },
            onOutgoingRequestDelete: { _ in },
            onOpenConversationsShowMore: { },
            onRefresh: { }
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
            canLoadMoreOpenConversations: false,
            onTabChangedToRequests: { },
            onTabChangedToConversations: { },
            onOpenComposer: { },
            onSelectOpenConversation: { _ in },
            onSelectActiveConversation: { _ in },
            onIncomingRequestAccept: { _ in },
            onIncomingRequestDecline: { _ in },
            onOutgoingRequestDelete: { _ in },
            onOpenConversationsShowMore: { },
            onRefresh: { }
        )
        .padding()
    }
}
