import Foundation

public struct APIResultResponse: Decodable {
    let success: Bool
    let error: String?
    
    public init(success: Bool, error: String?) {
        self.success = success
        self.error = error
    }
}
