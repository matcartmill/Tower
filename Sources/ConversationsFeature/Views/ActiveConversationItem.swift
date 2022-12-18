import CoreUI
import Models
import SwiftUI

struct ActiveConversationItem: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ProfileImage(User.sender.avatarUrl)
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(conversation.author.username)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(1)
                
                Text(conversation.messages.last!.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(1)
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
