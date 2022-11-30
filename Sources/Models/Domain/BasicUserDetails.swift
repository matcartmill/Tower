import Foundation

public struct BasicUserDetails: Equatable, Decodable {
    public let username: String
    public let avatar: URL?
    public let rating: Int?
    public let joined: Date
    
    public init(username: String, avatar: URL?, rating: Int?, joined: Date) {
        self.username = username
        self.avatar = avatar
        self.rating = rating
        self.joined = joined
    }
}
