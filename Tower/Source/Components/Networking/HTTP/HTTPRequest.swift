import Foundation

public struct HTTPRequest {
    let url: URL
    let method: HTTPMethod
}

extension URLRequest {
    public init(_ request: HTTPRequest) {
        self.init(url: request.url)
        self.httpMethod = request.method.rawValue
    }
}
