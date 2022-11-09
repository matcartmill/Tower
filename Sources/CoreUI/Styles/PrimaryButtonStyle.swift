import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    public init() { }
    
    private var backgroundColor: Color {
        return isEnabled
        ? Asset.Colors.Background.Button.primary.swiftUIColor
        : Asset.Colors.Background.Button.primaryDisabled.swiftUIColor
    }
    
    private var foregroundColor: Color {
        return isEnabled
        ? Asset.Colors.Content.Button.primary.swiftUIColor
        : Asset.Colors.Content.Button.primaryDisabled.swiftUIColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                configuration.isPressed
                    ? backgroundColor.opacity(0.7)
                    : backgroundColor
            )
            .foregroundColor(
                configuration.isPressed
                    ? foregroundColor.opacity(0.7)
                    : foregroundColor
            )
            .font(.body)
            .fontWeight(.bold)
            .clipShape(Capsule())
    }
}
