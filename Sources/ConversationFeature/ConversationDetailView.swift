import ComposableArchitecture
import CoreUI
import Models
import SwiftUI

public struct ConversationDetailView: View {
    public let store: StoreOf<ConversationDetail>
        
    public init(store: StoreOf<ConversationDetail>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            _ConversationDetailView(
                messages: viewStore.conversation.messages,
                user: viewStore.user,
                newMessage: viewStore.binding(get: \.newMessage, send: ConversationDetail.Action.textFieldChanged),
                sendMessage: { viewStore.send(.sendMessage) }
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: { viewStore.send(.showMoreMenu) }) {
                    Asset.Icons.more.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 28)
                        .tint(Asset.Colors.Content.primary.swiftUIColor)
                }
                .frame(alignment: .trailing)
            }
            .toolbar(.hidden, for: .tabBar)
            .actionSheet(
                isPresented: viewStore.binding(
                    get: \.isMoreMenuOpen,
                    send: ConversationDetail.Action.dismissMoreMenu
                )
            ) {
                ActionSheet(
                    title: Text("Options"),
                    buttons: [
                        ActionSheet.Button.default(Text("Report")),
                        ActionSheet.Button.destructive(Text("Leave conversation")) {
                            viewStore.send(.leave(viewStore.conversation.id))
                        },
                        ActionSheet.Button.cancel()
                    ]
                )
            }
            .task { await viewStore.send(.openWebSocket).finish() }
            .padding()
            .themedBackground()
        }
    }
}

private struct _ConversationDetailView: View {
    let messages: [Message]
    let user: User
    @Binding var newMessage: String
    let sendMessage: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { proxy in
                List {
                    ForEach(messages) { message in
                        ConversationMessage(
                            message: message,
                            user: user
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .onChange(of: messages) { newValue in
                    guard let last = newValue.last else { return }
                    
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            
            HStack(spacing: 16) {
                TextField(
                    "What's on your mind?",
                    text: $newMessage
                )
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Asset.Colors.Background.tertiary.swiftUIColor)
                .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .submitLabel(.send)
                .onSubmit {
                    guard !newMessage.isEmpty else { return }
                    
                    sendMessage()
                }
                
                Button(action: sendMessage) {
                    Asset.Icons.send.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .padding(8)
                        .tint(
                            newMessage.isEmpty
                            ? Asset.Colors.Content.Button.primaryDisabled.swiftUIColor
                            : Asset.Colors.Content.Button.primary.swiftUIColor
                        )
                }
                .padding(.top, 1)
                .padding(.trailing, 4)
                .background(
                    newMessage.isEmpty
                    ? Asset.Colors.Background.Button.primaryDisabled.swiftUIColor
                    : Asset.Colors.Background.Button.primary.swiftUIColor
                )
                .clipShape(Circle())
                .disabled(newMessage.isEmpty)
            }
        }
    }
}

private struct ConversationMessage: View {
    let message: Message
    let user: User
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.authorId == user.id {
                Spacer(minLength: 30)
                ConversationMessageContent(message: message, user: user)
            } else {
                ConversationMessageContent(message: message, user: user)
                Spacer(minLength: 30)
            }
        }
    }
}

private struct ConversationMessageContent: View {
    let message: Message
    let user: User
    
    private var foreground: Color {
        message.authorId == user.id
        ? .white
        : Asset.Colors.Content.primary.swiftUIColor
    }
    
    var body: some View {
        Text(message.content)
            .frame(alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .font(.callout)
            .foregroundColor(foreground)
            .background(
                message.authorId == user.id
                ? Asset.Colors.Background.Chat.outgoing.swiftUIColor
                : Asset.Colors.Background.Chat.incoming.swiftUIColor
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ConversationDetail_Previews: PreviewProvider {
    static var previews: some View {
        _ConversationDetailView(
            messages: [
                .init(
                    id: .init(),
                    authorId: User.lynn.id,
                    conversationId: .init(),
                    content: "Test one",
                    createdAt: Date()
                ),
                .init(
                    id: .init(),
                    authorId: User.mike.id,
                    conversationId: .init(),
                    content: "Test two",
                    createdAt: Date()
                ),
                .init(
                    id: .init(),
                    authorId: User.lynn.id,
                    conversationId: .init(),
                    content: "Test three",
                    createdAt: Date()
                )
            ],
            user: .lynn,
            newMessage: .constant(""),
            sendMessage: { }
        )
        .padding()
    }
}
