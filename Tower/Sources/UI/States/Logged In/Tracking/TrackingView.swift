import ComposableArchitecture
import SwiftUI

public struct TrackingView: View {
    public let store: StoreOf<Tracking>

    public init(store: StoreOf<Tracking>) {
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
                            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                        
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
                                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                Asset.Colors.Content.primary.swiftUIColor,
                                                lineWidth: 2
                                            )
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
                    Asset.Colors.Background.base.swiftUIColor
                        .ignoresSafeArea()
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Asset.Icons.account.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Asset.Colors.Content.primary.swiftUIColor)
                                .frame(alignment: .leading)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.openCalendar) }) {
                            Asset.Icons.calendar.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Asset.Colors.Content.primary.swiftUIColor)
                                .frame(alignment: .trailing)
                        }
                    }                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}
