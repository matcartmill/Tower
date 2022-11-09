import ComposableArchitecture
import CoreUI
import Models
import SwiftUI

public struct MyConversationsView: View {
    public let store: StoreOf<MyConversations>
    
    public init(store: StoreOf<MyConversations>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.conversations) { state in
                    ConversationListItem(conversation: state.conversation)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(.bottom, 28)
                        .onTapGesture {
                            viewStore.send(.selectedConversation(state))
                        }
                }
            }
            .padding(.horizontal)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .task { viewStore.send(.loadConversations) }
        }
    }
}

private struct ConversationListItem: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ProfileImage(User.sender)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(conversation.authorId.rawValue)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(1)
                
                Text(conversation.messages[0].content)
                    .font(.callout)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(2)
            }
            
            VStack(alignment: .trailing) {
                Text("2:34 PM")
                    .font(.footnote)
            }
        }
    }
}
