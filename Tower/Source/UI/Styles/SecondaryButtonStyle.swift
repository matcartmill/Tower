import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 46)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .foregroundColor(
                configuration.isPressed
                    ? Color("colors/content/button/secondary").opacity(0.7)
                    : Color("colors/content/button/secondary")
            )
            .background(
                configuration.isPressed
                    ? Color("colors/background/button/secondary").opacity(0.7)
                    : Color("colors/background/button/secondary")
            )
            .font(.callout)
            .fontWeight(.bold)
            .clipShape(Capsule())
    }
}
