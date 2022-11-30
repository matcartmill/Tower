import CoreUI
import SwiftUI

struct SegmentButton: View {
    let title: String
    var isActive: Bool
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(title) { action() }
                .padding(.bottom, 8)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(
                    isActive
                    ? Asset.Colors.Content.primary.swiftUIColor
                    : Asset.Colors.Content.secondary.swiftUIColor
                )
        }
    }
}
