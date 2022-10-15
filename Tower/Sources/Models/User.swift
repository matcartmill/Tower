import Foundation

public struct User: Codable, Equatable {
    public struct Metadata: Codable, Equatable {
        public var onboardingCompleted: Bool
        public var profileImageUrl: URL?
        
        public init(onboardingCompleted: Bool, profileImageUrl: URL?) {
            self.onboardingCompleted = onboardingCompleted
            self.profileImageUrl = profileImageUrl
        }
    }
    
    public let id: Identifier<Self>
    public var username: String?
    public var metadata: Metadata
    
    public init(username: String?, metadata: Metadata) {
        self.id = .init()
        self.username = username
        self.metadata = metadata
    }
}
