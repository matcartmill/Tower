import SwiftUI

public struct StarRating: View {
    private var emptyStars: Int { maxStars - stars }
    private let maxStars: Int = 5
    private let stars: Int
    
    public init(_ stars: Int) {
        self.stars = stars
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<stars, id: \.self) { _ in
                Asset.Icons.starFilled.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .tint(Asset.Colors.Content.primary.swiftUIColor)
            }
            ForEach(0..<emptyStars, id: \.self) { _ in
                Asset.Icons.starLine.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .tint(Asset.Colors.Content.primary.swiftUIColor)
            }
        }
    }
}
