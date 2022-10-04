import SwiftUI

struct UnderlinedTextFieldView: View {
    @Binding var text: String
    let placeholder: String?

    var body: some View {
        VStack {
            TextField(placeholder ?? "", text: $text)

            Rectangle().frame(height: 1)
                .foregroundColor(Color("colors/background/secondary"))
         }
     }
}
