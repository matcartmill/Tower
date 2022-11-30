import SwiftUI

public struct CalloutView<Content: View>: View {
    public struct Action {
        public let title: String
        public let execute: () -> Void
        
        public init(title: String, execute: @escaping (() -> Void)) {
            self.title = title
            self.execute = execute
        }
    }
    
    public let image: Image
    public let title: String
    public let details: String
    public let primaryAction: Action
    public let secondaryAction: Action?
    public var canProceed: Bool
    public let content: (() -> Content)?
    
    public init(
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
    
    public var body: some View {
        ViewThatFits(in: .vertical) {
            VStack(spacing: 32) {
                CalloutIcon(image: image)
                
                Group {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.9)
                    
                    Text(details)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.9)
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
            
            VStack(spacing: 28) {
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
}
