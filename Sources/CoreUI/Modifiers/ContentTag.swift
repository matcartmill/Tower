import SwiftUI

public struct ContentTagModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(.vertical, 3)
            .padding(.horizontal, 8)
            .foregroundColor(Asset.Colors.Content.tertiary.swiftUIColor)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Asset.Colors.Content.tertiary.swiftUIColor, lineWidth: 1)
            )
    }
}

public extension Text {
    func contentTag() -> some View {
        self.modifier(ContentTagModifier())
    }
}
