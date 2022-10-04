import ComposableArchitecture
import DomainKit
import SwiftUI

struct ConversationView: View {
    let store: ConversationStore
        
    init(store: ConversationStore) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                ScrollViewReader { proxy in
                    List {
                        ForEach(viewStore.conversation.messages) { message in
                            ConversationMessage(
                                message: message,
                                user: viewStore.user
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 20, trailing: 0))
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .onChange(of: viewStore.conversation.messages) { newValue in
                        guard let last = newValue.last else { return }
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                
                HStack(spacing: 16) {
                    TextField(
                        "What's on your mind?",
                        text: viewStore.binding(
                            get: \.newMessage,
                            send: ConversationAction.textFieldChanged
                        )
                    )
                    .padding(16)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(Color("colors/background/secondary"))
                    .foregroundColor(Color("colors/content/primary"))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .submitLabel(.send)
                    .onSubmit {
                        guard !viewStore.newMessage.isEmpty else { return }
                        
                        viewStore.send(.sendMessage)
                    }
                    
                    Button(action: { viewStore.send(.sendMessage) }) {
                        Image("icons/send")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .padding(8)
                            .tint(
                                viewStore.newMessage.isEmpty
                                ? Color("colors/content/button/primary_disabled")
                                : Color("colors/content/button/primary")
                            )
                    }
                    .padding(.top, 1)
                    .padding(.trailing, 4)
                    .background(
                        viewStore.newMessage.isEmpty
                        ? Color("colors/background/button/primary_disabled")
                        : Color("colors/background/button/primary")
                    )
                    .clipShape(Circle())
                    .disabled(viewStore.newMessage.isEmpty)
                }
            }
            .toolbar {
                Button(action: { viewStore.send(.showMoreMenu) }) {
                    Image("icons/more")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 28)
                        .tint(Color("colors/content/primary"))
                }
                .frame(alignment: .trailing)
            }
            .actionSheet(
                isPresented: viewStore.binding(
                    get: \.isMoreMenuOpen,
                    send: ConversationAction.dismissMoreMenu
                )
            ) {
                ActionSheet(
                    title: Text("Conversation Options"),
                    buttons: [
                        ActionSheet.Button.destructive(Text("Leave conversation")) {
                            viewStore.send(.leave(viewStore.conversation.id))
                        },
                        ActionSheet.Button.cancel()
                    ]
                )
            }
            .padding()
            .background(
                Color("colors/background/base")
                    .ignoresSafeArea()
            )
        }
    }
}

struct ConversationMessage: View {
    let message: Message
    let user: User
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.sender == user {
                Spacer(minLength: 30)
                ConversationMessageContent(message: message, user: user)
            } else {
                ConversationMessageContent(message: message, user: user)
                Spacer(minLength: 30)
            }
        }
    }
}

struct ConversationMessageContent: View {
    let message: Message
    let user: User
    
    private var foreground: Color {
        message.sender == user
            ? .white
            : Color("colors/content/primary")
    }
    
    var body: some View {
        Text(message.content)
            .frame(alignment: .leading)
            .padding(12)
            .font(.callout)
            .foregroundColor(foreground)
            .background(
                message.sender == user
                    ? Color("colors/background/chat/outgoing")
                    : Color("colors/background/chat/incoming")
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
