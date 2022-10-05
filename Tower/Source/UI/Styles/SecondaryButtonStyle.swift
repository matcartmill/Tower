import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(
                configuration.isPressed
                    ? Color("colors/content/button/secondary").opacity(0.7)
                    : Color("colors/content/button/secondary")
            )
            .font(.callout)
            .fontWeight(.bold)
    }
}
