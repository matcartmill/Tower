import ComposableArchitecture
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
                            ConversationMessage(message: message)
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
                
                HStack {
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
                        viewStore.send(.sendMessage)
                    }
                    
                    Button(action: {}) {
                        Image("icons/send")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .padding(8)
                            .tint(
                                viewStore.newMessage.isEmpty
                                ? Color("colors/content/button/primary_disabled")
                                : Color("colors/content/button/primary")
                            )
                    }
                    .background(
                        viewStore.newMessage.isEmpty
                        ? Color("colors/background/button/primary_disabled")
                        : Color("colors/background/button/primary")
                    )
                    .clipShape(Circle())
                }
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
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.sender == Participant.sender.id {
                Spacer(minLength: 30)
                ConversationMessageContent(message: message)
                ProfileImage(participant: .sender)
            } else {
                ProfileImage(participant: .receiver)
                ConversationMessageContent(message: message)
                Spacer(minLength: 30)
            }
        }
    }
}

struct ConversationMessageContent: View {
    let message: Message
    
    private var foreground: Color {
        message.sender == Participant.sender.id
            ? .white
            : Color("colors/content/primary")
    }
    
    private var gradient: Gradient {
        Gradient(colors: message.sender == Participant.sender.id
            ? [Color("colors/background/chat/outgoing_start"), Color("colors/background/chat/outgoing_end")]
            : [Color("colors/background/chat/incoming")]
        )
    }
    
    var body: some View {
        Text(message.content)
            .frame(alignment: .leading)
            .padding(12)
            .font(.callout)
            .foregroundColor(foreground)
            .background(
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}