import ComposableArchitecture
import SwiftUI

public struct TrackingView: View {
    private let taskGradients: [LinearGradient] = [
        LinearGradient(
            colors: [
                Color("colors/background/gradient/blue_start"),
                Color("colors/background/gradient/blue_end"),
            ],
            startPoint: .init(x: 0, y: 0),
            endPoint: .init(x: 1, y: 1)
        ),
        LinearGradient(
            colors: [
                Color("colors/background/gradient/purple_start"),
                Color("colors/background/gradient/purple_end"),
            ],
            startPoint: .init(x: 0, y: 0),
            endPoint: .init(x: 1, y: 1)
        ),
        LinearGradient(
            colors: [
                Color("colors/background/gradient/yellow_start"),
                Color("colors/background/gradient/yellow_end"),
            ],
            startPoint: .init(x: 0, y: 0),
            endPoint: .init(x: 1, y: 1)
        )
    ]
    
    @State private var foo = false
    public let store: TrackingStore

    public init(store: TrackingStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("TASKS")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color("colors/content/primary"))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(viewStore.tasks) { task in
                                    Button(action: {} ) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(task.title)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                            
                                            Text(task.description)
                                                .font(.footnote)
                                                .fontWeight(.bold)
                                                .lineLimit(3)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .frame(maxWidth: 160)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .foregroundColor(Color("colors/content/primary"))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Color("colors/content/primary"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(
                    Color("colors/background/base")
                        .ignoresSafeArea()
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Image("icons/account")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Color("colors/content/primary"))
                                .frame(alignment: .leading)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.openCalendar) }) {
                            Image("icons/calendar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Color("colors/content/primary"))
                                .frame(alignment: .trailing)
                        }
                    }                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}
