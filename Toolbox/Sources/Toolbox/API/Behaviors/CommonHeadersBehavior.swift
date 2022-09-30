import Foundation

/// A behavior that adds headers to a request
class CommonHeadersBehavior: APIBehavior {

    /// A function that returns the headers to add to the request
    private let headers: () -> [String: String]

    /// Initializes a new instance
    /// - Parameter headers: A function that returns the headers to add to the request
    init(headers: @escaping () -> [String: String]) {
        self.headers = headers
    }

    /// Modifies the headers of the URL request being performed
    ///
    /// This behavior does _not_ override headers that are already set on the request.
    ///
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the behavior can modify
    /// - Returns: A modified or unmodified request
    func client<T: APIOperation>(_ client: APIClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        var request = request

        let headers = self.headers()
        let existing = request.allHTTPHeaderFields.or([:]).keys

        for key in headers.keys where !existing.contains(key) {
            request.addValue(headers[key]!, forHTTPHeaderField: key)
        }

        return request
    }
}
