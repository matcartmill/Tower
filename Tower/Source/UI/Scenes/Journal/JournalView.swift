import ComposableArchitecture
import SwiftUI

public struct JournalView: View {
    public let store: JournalStore

    public init(store: JournalStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(viewStore.tasks) {
                            Text($0.title)
                                .padding()
                                .background(Color("colors/background/secondary"))
                                .foregroundColor(Color("colors/content/secondary"))
                                .clipShape(Capsule())
                        }
                    }
                }
                
                Text("Hello!")
            }
            .background(
                Color("colors/background/base")
                    .ignoresSafeArea()
            )
            .padding()
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}
