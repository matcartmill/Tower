import DomainKit
import SwiftUI

public struct ProfileImage: View {
    private let user: User
    
    public init(_ user: User) {
        self.user = user
    }
    
    public var body: some View {
        AsyncImage(
            url: user.metadata.profileImageUrl,
            content: { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .empty, .failure:
                    defaultProfileImage
                    
                @unknown default:
                    defaultProfileImage
                }
            }
        )
        .clipShape(Circle())
    }
    
    private var defaultProfileImage: some View {
        ZStack {
            Asset.Colors.Background.Paint.steel.swiftUIColor
            Asset.Icons.chatBubble.swiftUIImage
                .resizable()
                .foregroundColor(.white)
                .padding(9)
        }
    }
}
