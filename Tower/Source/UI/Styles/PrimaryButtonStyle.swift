import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    private var backgroundColor: Color {
        return isEnabled
        ? Color("colors/background/button/primary")
        : Color("colors/background/button/primary_disabled")
            
    }
    
    private var foregroundColor: Color {
        return isEnabled
        ? Color("colors/content/button/primary")
        : Color("colors/content/button/primary_disabled")
            
    }
    
    func makeBody(configuration: Configuration) -> some View {
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
            .font(.callout)
            .fontWeight(.bold)
            .clipShape(Capsule())
    }
}
