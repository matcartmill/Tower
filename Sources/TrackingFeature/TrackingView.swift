import CalendarFeature
import ComposableArchitecture
import CoreUI
import Models
import SwiftUI

public struct TrackingView: View {
    public let store: StoreOf<Tracking>

    public init(store: StoreOf<Tracking>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                VStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        Text("TASKS")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(viewStore.tasks) { task in
                                    Button(action: {}) {
                                        VStack(spacing: 0) {
                                            Group {
                                                VStack(spacing: 18) {
                                                    Text(task.title)
                                                        .font(.callout)
                                                        .fontWeight(.bold)
                                                    
                                                    Text(task.description)
                                                        .font(.footnote)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            if task.optedIn {
                                                HStack {
                                                    Text("Opted In")
                                                        .font(.footnote)
                                                        .fontWeight(.bold)
                                                    
                                                    Asset.Icons.checkCircle.swiftUIImage
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .tint(Asset.Colors.Content.primary.swiftUIColor)
                                                }
                                                .padding(.bottom, 6)
                                            } else {
                                                Text("Opt In")
                                                    .font(.footnote)
                                                    .fontWeight(.bold)
                                                    .padding(.vertical, 6)
                                                    .padding(.horizontal, 24)
                                                    .overlay(
                                                        Capsule()
                                                            .strokeBorder(Asset.Colors.Content.primary.swiftUIColor, lineWidth: 1)
                                                    )
                                            }
                                        }
                                        .padding(.vertical, 18)
                                        .padding(.horizontal, 10)
                                    }
                                    .frame(width: 160, height: 220)
                                    .background(Asset.Colors.Background.tertiary.swiftUIColor)
                                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 36) {
                        Text("Right now I'm feeling...")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                        
                        HStack(spacing: 30) {
                            ForEach(Emotion.allCases, id: \.self) { emotion in
                                EmotionView(
                                    emotion: emotion,
                                    isSelected: emotion == viewStore.selectedEmotion
                                ) {
                                    viewStore.send(.selectEmotion(emotion))
                                }
                            }
                        }
                        
                        Button("Track") { viewStore.send(.confirmEmotionSelection) }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(Asset.Colors.Background.Button.primary.swiftUIColor)
                            .foregroundColor(Asset.Colors.Content.Button.primary.swiftUIColor)
                            .font(.body)
                            .fontWeight(.bold)
                            .clipShape(Capsule())
                            .disabled(viewStore.selectedEmotion == nil)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(
                    Asset.Colors.Background.base.swiftUIColor
                        .ignoresSafeArea()
                )
                .navigationTitle(Text("Tracking"))
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: { viewStore.send(.openAccount) }) {
                            Asset.Icons.account.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Asset.Colors.Content.primary.swiftUIColor)
                                .frame(alignment: .leading)
                        }
                        
                        Button(action: { viewStore.send(.openCalendar) }) {
                            Asset.Icons.calendar.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(Asset.Colors.Content.primary.swiftUIColor)
                                .frame(alignment: .trailing)
                        }
                    }
                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
            .sheet(
                isPresented: viewStore.binding(
                    get: { $0.calendarState != nil },
                    send: Tracking.Action.calendar(.dismiss)
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.calendarState,
                        action: Tracking.Action.calendar
                    )
                ) {
                    CalendarView(store: $0)
                }
            }
        }
    }
}

private struct EmotionView: View {
    let emotion: Emotion
    let isSelected: Bool
    let action: () -> Void
    
    var icon: Image {
        switch emotion {
        case .sad:
            return isSelected
            ? Asset.Icons.emotionSadFilled.swiftUIImage
            : Asset.Icons.emotionSadLine.swiftUIImage
            
        case .neutral:
            return isSelected
            ? Asset.Icons.emotionNeutralFilled.swiftUIImage
            : Asset.Icons.emotionNeutralLine.swiftUIImage
            
        case .content:
            return isSelected
            ? Asset.Icons.emotionSmileFilled.swiftUIImage
            : Asset.Icons.emotionSmileLine.swiftUIImage
            
        case .happy:
            return isSelected
            ? Asset.Icons.emotionHappyFilled.swiftUIImage
            : Asset.Icons.emotionHappyLine.swiftUIImage
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                icon
                    .resizable()
                    .frame(width: 40, height: 40)
                    .tint(
                        isSelected
                        ? Asset.Colors.Background.Paint.yellow.swiftUIColor
                        : Asset.Colors.Content.primary.swiftUIColor
                    )
                
                Text(emotion.description)
                    .font(.callout)
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
            }
        }
    }
}

extension Emotion {
    var description: String {
        switch self {
        case .sad: return "Sad"
        case .neutral: return "Neutral"
        case .content: return "Content"
        case .happy: return "Happy"
        }
    }
}
