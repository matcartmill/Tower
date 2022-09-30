import ComposableArchitecture
import DomainKit
import SwiftUI

struct ConversationsView: View {
    let store: ConversationsStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    List {
                        ForEach(viewStore.conversations) { state in
                            ConversationListItem(conversation: state.conversation)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .padding()
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
                                    send: ConversationsAction.dismissConversation
                                )) {
                                    IfLetStore(
                                        store.scope(
                                            state: \.selectedConversation,
                                            action: ConversationsAction.conversation
                                        ),
                                        then: {
                                            ConversationView(store: $0)
                                        }
                                    )
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    
                    Button(action: { viewStore.send(.openComposer) }) {
                        Image("icons/compose")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .padding(18)
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
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.openAccount) }) {
                            HStack(spacing: 6) {
                                Image("icons/conversation")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .tint(Color("colors/content/button/secondary"))
                                
                                Text("2")
                                    .font(.footnote.bold())
                                    .foregroundColor(Color("colors/content/button/secondary"))
                            }
                            .padding(.vertical, 3)
                            .padding(.horizontal, 12)
                            .background(Color("colors/background/button/secondary"))
                            .clipShape(Capsule())
                        }
                    }
                }
                .onAppear { viewStore.send(.viewShown) }
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: viewStore.binding(
                    get: { $0.newConversation != nil },
                    send: ConversationsAction.compose(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.newConversation,
                            action: ConversationsAction.compose
                        )
                    ) {
                        ComposeView(store: $0)
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.accountState != nil },
                    send: ConversationsAction.account(.close)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.accountState,
                            action: ConversationsAction.account
                        )
                    ) {
                        AccountView(store: $0)
                    }
                }
            }
        }
    }
}

struct ConversationListItem: View {
    let conversation: Conversation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(conversation.messages[0].content)
                .font(.headline)
                .foregroundColor(Color("colors/content/primary"))
                .lineLimit(2)
            
            HStack {
                Text("\(conversation.participants.count) participants")
                    .font(.footnote)
                    .foregroundColor(Color("colors/content/secondary"))
                
                Text("Posted 1 min ago")
                    .font(.footnote)
                    .foregroundColor(Color("colors/content/secondary"))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(store: .init(
            initialState: .init(conversations: [], user: .sender),
            reducer: conversationsReducer,
            environment: .live
        ))
    }
}
