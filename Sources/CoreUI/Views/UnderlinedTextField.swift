import SwiftUI

public struct UnderlinedTextFieldView: View {
    @Binding public var text: String
    public let placeholder: String?

    public init(text: Binding<String>, placeholder: String?) {
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack {
            TextField(placeholder ?? "", text: $text)

            Rectangle().frame(height: 1)
                .foregroundColor(Asset.Colors.Background.secondary.swiftUIColor)
         }
     }
}
