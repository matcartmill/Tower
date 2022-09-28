import Foundation

public struct AppEnvironment {
    public let mainQueue: DispatchQueue
    public let authEnvironment: AuthEnvironment
    public let homeEnvironment: HomeEnvironment
}

extension AppEnvironment {
    public static let live: Self = .init(
        mainQueue: .main,
        authEnvironment: .live,
        homeEnvironment: .live
    )
    
    public static let mock: Self = .init(
        mainQueue: .main,
        authEnvironment: .mock,
        homeEnvironment: .mock
    )
}
