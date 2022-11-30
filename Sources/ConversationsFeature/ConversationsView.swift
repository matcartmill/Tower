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
                List {
                    Section {
                        EmptyView()
                    } header: {
                        TabSelector(
                            selectedTab: viewStore.activeTab,
                            onOpenRequestsSelected: { viewStore.send(.viewOpenRequests, animation: .spring()) },
                            onMyConversationsSelected: { viewStore.send(.viewMyConversations, animation: .spring()) }
                        )
                        .themedRow()
                    }

                    if viewStore.activeTab == .openConversations {
                        if !viewStore.incomingRequests.requests.isEmpty {
                            IncomingRequestsSection(requests: viewStore.incomingRequests.requests)
                                .themedRow()
                        }
                        
                        if !viewStore.outgoingRequests.requests.isEmpty {
                            OutgoingRequestsSection(requests: viewStore.outgoingRequests.requests)
                                .themedRow()
                        }
                        
                        OpenConversationsSection(conversations: viewStore.openConversations.conversations)
                            .themedRow()
                    } else {
                        ActiveConversationsSection(conversations: viewStore.activeConversations.conversations)
                            .themedRow()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .themedBackground()
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
                .overlay(alignment: .bottomTrailing) {
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
            }
        }
    }
}

private struct OpenConversationsSection: View {
    let conversations: IdentifiedArrayOf<ConversationSummary>
    
    var body: some View {
        Section(LocalizedStringKey("Open Conversations")) {
            ForEach(conversations) {
                OpenConversationItem(conversation: $0)
            }
        }
    }
}

private struct ActiveConversationsSection: View {
    let conversations: IdentifiedArrayOf<Conversation>
    
    var body: some View {
        ForEach(conversations) {
            ActiveConversationItem(conversation: $0)
        }
    }
}
