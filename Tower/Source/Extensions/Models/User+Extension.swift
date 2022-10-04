import DomainKit

extension User {
    static let sender: Self = .init(
        username: "j4cksparr0w",
        metadata: .init(onboardingCompleted: true, profileImageUrl: nil)
    )
    static let receiver: Self = .init(
        username: "windycitymike",
        metadata: .init(onboardingCompleted: true, profileImageUrl: nil)
    )
}
