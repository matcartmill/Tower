import ComposableArchitecture
import DomainKit
import SwiftUI

public struct ConversationDetailView: View {
    public let store: StoreOf<ConversationDetail>
        
    public init(store: StoreOf<ConversationDetail>) {
        self.store = store
    }
    
    public var body: some View {
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
                            send: ConversationDetail.Action.textFieldChanged
                        )
                    )
                    .padding(16)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(Asset.Colors.Background.secondary.swiftUIColor)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
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
                                ? Asset.Colors.Content.Button.primaryDisabled.swiftUIColor
                                : Asset.Colors.Content.Button.primary.swiftUIColor
                            )
                    }
                    .padding(.top, 1)
                    .padding(.trailing, 4)
                    .background(
                        viewStore.newMessage.isEmpty
                        ? Asset.Colors.Background.Button.primaryDisabled.swiftUIColor
                        : Asset.Colors.Background.Button.primary.swiftUIColor
                    )
                    .clipShape(Circle())
                    .disabled(viewStore.newMessage.isEmpty)
                }
            }
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
            .padding()
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
        }
    }
}

private struct ConversationMessage: View {
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

private struct ConversationMessageContent: View {
    let message: Message
    let user: User
    
    private var foreground: Color {
        message.sender == user
        ? .white
        : Asset.Colors.Content.primary.swiftUIColor
    }
    
    var body: some View {
        Text(message.content)
            .frame(alignment: .leading)
            .padding(12)
            .font(.callout)
            .foregroundColor(foreground)
            .background(
                message.sender == user
                ? Asset.Colors.Background.Chat.outgoing.swiftUIColor
                : Asset.Colors.Background.Chat.incoming.swiftUIColor
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
