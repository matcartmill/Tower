import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    @Environment (\.isEnabled) private var isEnabled
    
    public init() { }
    
    private var foregrouncColor: Color {
        isEnabled
        ? Asset.Colors.Content.Button.secondary.swiftUIColor
        : Asset.Colors.Content.Button.secondaryDisabled.swiftUIColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(
                configuration.isPressed
                    ? foregrouncColor.opacity(0.7)
                    : foregrouncColor
            )
            .font(.body)
            .fontWeight(.bold)
    }
}
