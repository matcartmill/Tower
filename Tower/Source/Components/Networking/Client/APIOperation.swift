import Foundation

public protocol APIOperation {
    associatedtype Response
    func createRequest() throws -> HTTPRequest
    func handleResponse(_ data: Data) throws -> Response
}

extension APIOperation where Response: Decodable {
    public func defaultHandler(data: Data) throws -> Response {
        return try APIClient.defaultJSONDecoder.decode(Response.self, from: data)
    }
    
    public func handleResponse(_ data: Data) throws -> Response {
        return try defaultHandler(data: data)
    }
}

extension APIOperation where Response == Void {
    public func handleResponse(_ data: Data) throws -> Response { return }
}

