import Foundation

public struct AppEnvironment {
    public let mainQueue: DispatchQueue
    public let authEnvironment: AuthEnvironment
    public let conversationsEnvironment: ConversationsEnvironment
    public let journalEnvironment: JournalEnvironment
}

extension AppEnvironment {
    public static let live: Self = .init(
        mainQueue: .main,
        authEnvironment: .live,
        conversationsEnvironment: .live,
        journalEnvironment: .init()
    )
    
    public static let mock: Self = .init(
        mainQueue: .main,
        authEnvironment: .mock,
        conversationsEnvironment: .mock,
        journalEnvironment: .init()
    )
}
