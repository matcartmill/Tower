import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: HomeStore
    
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
                                    send: HomeAction.dismissConversation
                                )) {
                                    IfLetStore(
                                        store.scope(
                                            state: \.selectedConversation,
                                            action: HomeAction.conversation
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Image("icons/account")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Color("colors/content/primary"))
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: viewStore.binding(
                    get: { $0.newConversation != nil },
                    send: HomeAction.compose(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.newConversation,
                            action: HomeAction.compose
                        )
                    ) {
                        ComposeView(store: $0)
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.accountState != nil },
                    send: HomeAction.account(.close)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.accountState,
                            action: HomeAction.account
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
        HStack(alignment: .top, spacing: 12) {
            if let owner = conversation.participants.first(where: { $0.id == conversation.messages.first?.sender }) {
                ProfileImage(participant: owner)
            } else {
                Color("colors/background/secondary")
                    .frame(width: 40, height: 40, alignment: .leading)
                    .clipShape(Circle())
            }
            
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(
            initialState: .init(conversations: [], user: .sender),
            reducer: homeReducer,
            environment: .live
        ))
    }
}
