import CoreUI
import Models
import SwiftUI

struct OpenConversationItem: View {
    let conversation: ConversationSummary
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(conversation.summary)
                    .font(.callout)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .lineLimit(2)
                
                HStack(spacing: 24) {
                    HStack(spacing: 4) {
                        Text("Joined")
                            .font(.footnote)
                            .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                        
                        Text("3 weeks ago")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                    }
                    
                    StarRating(3)
                        .frame(height: 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CategoryTag("Addiction")
        }
    }
}
