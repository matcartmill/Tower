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
                .sheet(isPresented: viewStore.binding(
                    get: { $0.conversationOnboardingState != nil },
                    send: ConversationsAction.onboarding(.cancel)
                )) {
                    IfLetStore(
                        store.scope(
                            state: \.conversationOnboardingState,
                            action: ConversationsAction.onboarding
                        )
                    ) {
                        ConversationOnboardingView(store: $0)
                            .presentationDetents([.fraction(0.45)])
                    }
                }
            }
        }
    }
}

struct ConversationListItem: View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(store: .init(
            initialState: .init(conversations: [], user: .sender),
            reducer: conversationsReducer,
            environment: .live
        ))
    }
}
