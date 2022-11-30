import CoreUI
import Models
import SwiftUI

struct ActiveConversationItem: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ProfileImage(User.sender.avatarUrl)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(conversation.author.username)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(1)
                
                Text(conversation.messages.last!.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.callout)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .trailing) {
                Text("2:34 PM")
                    .font(.footnote)
            }
        }
        .padding(.vertical, 14)
    }
}
