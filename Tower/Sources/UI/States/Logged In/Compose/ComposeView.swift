import ComposableArchitecture
import SwiftUI

public struct ComposeView: View {
    @FocusState private var isComposingFocused: Bool
    
    public let store: StoreOf<Compose>
    
    public init(store: StoreOf<Compose>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 24) {
                HStack {
                    Button(action: { viewStore.send(.close) }) {
                        Text("Cancel")
                            .font(.callout)
                            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    }
                    
                    Spacer()
                    
                    Button(action: { viewStore.send(.start) }) {
                        Text("Post")
                            .padding(.horizontal, 18)
                            .padding(.vertical, 6)
                            .font(.subheadline.bold())
                            .foregroundColor(
                                viewStore.message.isEmpty
                                ? Asset.Colors.Content.Button.primaryDisabled.swiftUIColor
                                : Asset.Colors.Content.Button.primary.swiftUIColor
                            )
                    }
                    .background(
                        viewStore.message.isEmpty
                        ? Asset.Colors.Background.Button.primaryDisabled.swiftUIColor
                        : Asset.Colors.Background.Button.primary.swiftUIColor
                    )
                    .clipShape(Capsule())
                }
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Text("Public")
                                .font(.caption)
                                .foregroundColor(Asset.Colors.Content.Button.secondary.swiftUIColor)
                            Asset.Icons.arrowDown.swiftUIImage
                                .resizable()
                                .frame(width: 14, height: 14)
                                .tint(Asset.Colors.Content.Button.secondary.swiftUIColor)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    .background(Asset.Colors.Background.Button.secondary.swiftUIColor)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField(
                    "What's on your mind?",
                    text: viewStore.binding(
                        get: \.message,
                        send: Compose.Action.textFieldChanged
                    ),
                    axis: .vertical
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                .focused($isComposingFocused)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
        }
    }
}
