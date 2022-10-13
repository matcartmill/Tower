import SwiftUI

struct CalloutView<Content: View>: View {
    struct Action {
        let title: String
        let execute: () -> Void
    }
    
    let image: Image
    let title: String
    let details: String
    let primaryAction: Action
    let secondaryAction: Action?
    var canProceed: Bool
    let content: (() -> Content)?
    
    init(
        image: Image,
        title: String,
        details: String,
        primaryAction: Action,
        secondaryAction: Action? = nil,
        canProceed: Bool,
        content: (() -> Content)? = nil
    ) {
        self.image = image
        self.title = title
        self.details = details
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.canProceed = canProceed
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 32) {
            CalloutIcon(image: image)
            
            Group {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    .multilineTextAlignment(.center)
                
                Text(details)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            
            content?()
            
            Button(primaryAction.title) { primaryAction.execute() }
                .frame(width: 260)
                .disabled(!canProceed)
                .buttonStyle(PrimaryButtonStyle())
            
            if let secondaryAction = secondaryAction {
                Button(secondaryAction.title) { secondaryAction.execute() }
                    .buttonStyle(SecondaryButtonStyle())
            }
                
        }
    }
}
