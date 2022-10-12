import ComposableArchitecture
import DomainKit
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
                            .foregroundColor(Color("colors/content/primary"))
                    }
                    
                    Spacer()
                    
                    Button(action: { viewStore.send(.start) }) {
                        Text("Post")
                            .padding(.horizontal, 18)
                            .padding(.vertical, 6)
                            .font(.subheadline.bold())
                            .foregroundColor(
                                viewStore.message.isEmpty
                                ? Color("colors/content/button/primary_disabled")
                                : Color("colors/content/button/primary")
                            )
                    }
                    .background(
                        viewStore.message.isEmpty
                        ? Color("colors/background/button/primary_disabled")
                        : Color("colors/background/button/primary")
                    )
                    .clipShape(Capsule())
                }
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Text("Public")
                                .font(.caption)
                                .foregroundColor(Color("colors/content/button/secondary"))
                            Image("icons/arrow_down")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .tint(Color("colors/content/button/secondary"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    .background(Color("colors/background/button/secondary"))
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
                .foregroundColor(Color("colors/content/primary"))
                .focused($isComposingFocused)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color("colors/background/base").ignoresSafeArea())
        }
    }
}
