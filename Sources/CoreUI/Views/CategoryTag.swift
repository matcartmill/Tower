import SwiftUI

public struct CategoryTag: View {
    private let category: String
    
    public init(_ category: String) {
        self.category = category
    }
    
    public var body: some View {
        Text(category)
            .padding(.vertical, 3)
            .padding(.horizontal, 8)
            .font(.caption)
            .foregroundColor(Asset.Colors.Content.tertiary.swiftUIColor)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Asset.Colors.Content.tertiary.swiftUIColor, lineWidth: 1)
            )
        
    }
}
