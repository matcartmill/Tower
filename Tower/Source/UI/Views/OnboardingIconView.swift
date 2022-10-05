import SwiftUI

struct OnboardingIconView: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: 50, height: 50)
            .padding(25)
            .background(
                LinearGradient(
                    colors: [
                        Color("colors/background/gradient/blue_start"),
                        Color("colors/background/gradient/blue_end"),
                    ],
                    startPoint: .init(x: 0, y: 0.2),
                    endPoint: .init(x: 0, y: 0.8)
                )
            )
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
