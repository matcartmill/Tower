import Models
import SwiftUI

public struct ProfileImage: View {
    private let url: URL?
    
    public init(_ url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(
            url: url,
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
