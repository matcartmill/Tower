import DomainKit
import Foundation

public struct TrackingState: Equatable {
    var tasks: [Task] = [
        .init(
            title: "Track your mood",
            description: "Tracking your mood daily can help by creating trend lines",
            frequency: .daily
        ),
        .init(
            title: "Chat with someone",
            description: "Having a conversation someone can be a powerful way to feel connected",
            frequency: .weekly
        ),
        .init(
            title: "Meditate",
            description: "Spending just five minutes per day can help with putting your mind at ease",
            frequency: .daily
        )
    ]
}
