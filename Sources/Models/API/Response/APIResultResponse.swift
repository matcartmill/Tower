import Foundation

public struct APIResultResponse: Decodable {
    public let success: Bool
    public let error: String?
    
    public init(success: Bool, error: String?) {
        self.success = success
        self.error = error
    }
}
