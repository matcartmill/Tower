import SwiftUI

public struct BaseBackgroundModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
    }
}

public extension View {
    func themedBackground() -> some View {
        self.modifier(BaseBackgroundModifier())
    }
}
