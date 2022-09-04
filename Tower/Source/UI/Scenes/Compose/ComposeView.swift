import SwiftUI
import ComposableArchitecture

struct ComposeView: View {
    @FocusState private var isComposingFocused: Bool
    
    let store: ComposeStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color("colors/background/base")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack {
                        Button(action: { viewStore.send(.cancel) }) {
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
                        ProfileImage(participant: viewStore.user)
                        
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
                            send: ComposeAction.textFieldChanged
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .foregroundColor(Color("colors/content/primary"))
                    .focused($isComposingFocused)
                }
                .onAppear {
                    viewStore.send(.viewLoaded)
                }
                .onChange(of: viewStore.isComposingFocused) {
                    isComposingFocused = $0
                }
                .onChange(of: isComposingFocused) {
                    viewStore.send(.binding(.set(\.$isComposingFocused, $0)))
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}

struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeView(store: .init(
            initialState: .init(conversation: .init(participants: [Participant.sender], messages: [])),
            reducer: composeReducer,
            environment: .live
        ))
    }
}
