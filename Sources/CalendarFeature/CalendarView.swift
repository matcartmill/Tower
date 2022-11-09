import ComposableArchitecture
import CoreUI
import SwiftUI

public struct CalendarView: View {
    public let store: StoreOf<CalendarReducer>
    
    public init(store: StoreOf<CalendarReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            Grid {
                GridRow {
                    ForEach(viewStore.dataSource.header.days.indices, id: \.self) {
                        Text("\(viewStore.dataSource.header.days[$0])")
                    }
                }
                ForEach(viewStore.dataSource.rows) { row in
                    GridRow {
                        ForEach(row.dates.indices, id: \.self) { index in
                            switch row.dates[index] {
                            case .actual(let date, let current):
                                DateView(
                                    date: date,
                                    isCurrentDate: current,
                                    hasActivity: false
                                )
                                
                            case .empty:
                                Color.clear
                                    .gridCellUnsizedAxes([.horizontal, .vertical])
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
        }
    }
}

struct DateView: View {
    let date: Int
    let isCurrentDate: Bool
    let hasActivity: Bool
    
    private var backgroundColor: Color {
        isCurrentDate
        ? Asset.Colors.Background.Button.primary.swiftUIColor
        : Color.clear
    }
    
    private var foregroundColor: Color {
        isCurrentDate
        ? Asset.Colors.Content.Button.primary.swiftUIColor
        : Asset.Colors.Content.primary.swiftUIColor
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(date)")
                .frame(width: 30)
                .padding(.vertical, 10)
                .padding(.horizontal, 4)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            if hasActivity {
                Color.gray
                    .frame(width: 4, height: 4)
                    .clipShape(Circle())
            }
        }
    }
}

struct CalendarPreviews: PreviewProvider {
    static var previews: some View {
        CalendarView(
            store: .init(
                initialState: .init(),
                reducer: CalendarReducer()
            )
        )
    }
}
