import ComposableArchitecture
import DomainKit
import SwiftUI

public struct ConversationsView: View {
    public let store: StoreOf<Conversations>
    
    public init(store: StoreOf<Conversations>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    List {
                        ForEach(viewStore.conversations) { state in
                            ConversationListItem(conversation: state.conversation)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .padding(.vertical)
                                .onTapGesture {
                                    viewStore.send(.openConversation(id: state.conversation.id))
                                }
                                .navigationDestination(isPresented: viewStore.binding(
                                    get: {
                                        guard
                                            let conversation = $0.selectedConversation,
                                            conversation.id == state.conversation.id
                                        else { return false }
                                        
                                        return true
                                    },
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
                        }
                    }
                    .padding()
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    
                    Button(action: { viewStore.send(.openComposer) }) {
                        Image("icons/plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .padding(12)
                            .tint(Color("colors/content/button/primary"))
                    }
                    .background(Color("colors/background/button/primary"))
                    .clipShape(Circle())
                    .padding([.bottom, .trailing], 30)
                }
                .background(
                    Color("colors/background/base")
                        .ignoresSafeArea()
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Image("icons/account")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Color("colors/content/primary"))
                                .frame(alignment: .leading)
                        }
                    }
                }
                .onAppear { viewStore.send(.viewShown) }
                .navigationBarTitleDisplayMode(.inline)
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

private struct ConversationListItem: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ProfileImage(conversation.author)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(conversation.messages[0].sender.username)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("colors/content/primary"))
                    .lineLimit(1)
                
                Text(conversation.messages[0].content)
                    .font(.callout)
                    .foregroundColor(Color("colors/content/primary"))
                    .lineLimit(2)
            }
            
            VStack(alignment: .trailing) {
                Text("2:34 PM")
                    .font(.footnote)
                Text("2")
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .clipShape(Circle())
            }
        }
    }
}
