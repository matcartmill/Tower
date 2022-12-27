import CoreUI
import Models
import SwiftUI

struct IncomingRequestItem: View {
    let userDetails: BasicUserDetails
    let acceptAction: () -> Void
    let declineAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ProfileImage(userDetails.avatar)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(userDetails.username)
                    .frame(alignment: .leading)
                    .font(.body)
                    .bold()
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                
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
            
            Button(action: declineAction) {
                Asset.Icons.crossCircle.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(Asset.Colors.Content.primary.swiftUIColor)
            }
            .buttonStyle(.plain)
            
            Button(action: acceptAction) {
                Asset.Icons.checkCircle.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(Asset.Colors.Content.primary.swiftUIColor)
            }
            .buttonStyle(.plain)
        }
    }
}
