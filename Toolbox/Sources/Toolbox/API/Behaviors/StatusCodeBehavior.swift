import Foundation

/// A behavior that validates the status code of a response
public class StatusCodeAPIBehavior: APIBehavior {

    /// An error that can be thrown during validation
    enum StatusCodeError: Error {
        /// Thrown if the response is invalid
        case invalidResponse
        /// Thrown if the status code isn't valid
        case invalidStatusCode(Int)
    }

    /// The range of accepted status codes
    private let range: Range<Int>

    /// Initializes a new instance
    /// - Parameter accepted: The range of accepted status codes
    public init(accepted: Range<Int>) {
        self.range = accepted
    }

    /// Validates that the status code received is within the accepted range
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    public func client<T: APIOperation>(_ client: APIClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws {
        let (_, response, _) = response
        guard let http = response as? HTTPURLResponse else { throw StatusCodeError.invalidResponse }
        guard range.contains(http.statusCode) else { throw StatusCodeError.invalidStatusCode(http.statusCode) }
    }
}
