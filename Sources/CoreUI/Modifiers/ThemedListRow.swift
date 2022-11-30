import SwiftUI

public struct ThemedListRow: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .listRowBackground(Asset.Colors.Background.base.swiftUIColor)
    }
}

public extension View {
    func themedRow() -> some View {
        self.modifier(ThemedListRow())
    }
}
