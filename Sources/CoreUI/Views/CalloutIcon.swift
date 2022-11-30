import SwiftUI

struct CalloutIcon: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(minHeight: 30, maxHeight: 50)
            .padding(25)
            .background(
                LinearGradient(
                    colors: [
                        Asset.Colors.Background.Gradient.blueStart.swiftUIColor,
                        Asset.Colors.Background.Gradient.blueEnd.swiftUIColor
                    ],
                    startPoint: .init(x: 0, y: 0.2),
                    endPoint: .init(x: 0, y: 0.8)
                )
            )
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
