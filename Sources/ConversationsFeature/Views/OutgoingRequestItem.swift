import CoreUI
import Models
import SwiftUI

struct OutgoingRequestItem: View {
    let request: OutgoingConversationRequest
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                Text(request.summary.summary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.callout)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                
                CategoryTag("Finance")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: { }) {
                Asset.Icons.crossCircle.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(Asset.Colors.Content.primary.swiftUIColor)
            }
        }
    }
}

