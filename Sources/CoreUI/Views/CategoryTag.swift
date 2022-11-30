import SwiftUI

public struct CategoryTag: View {
    private let category: String
    
    public init(_ category: String) {
        self.category = category
    }
    
    public var body: some View {
        Text(category)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .font(.footnote)
            .foregroundColor(Asset.Colors.Content.tertiary.swiftUIColor)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Asset.Colors.Content.tertiary.swiftUIColor, lineWidth: 2)
            )
        
    }
}
