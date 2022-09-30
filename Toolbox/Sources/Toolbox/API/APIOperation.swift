import Foundation

/// Protocol to implement for an `Operation` that can be used with the `APIClient`
public protocol APIOperation {

    /// The type of the response returned as a result of the `handleResponse(_:)` method
    associatedtype Response

    /// Generate a `URLRequest` for this `Operation`.
    ///
    /// This method is called by the `APIClient`.
    func makeRequest() throws -> URLRequest

    /// Handle the raw response object returned by the server.
    ///
    /// This method is called by the `APIClient` after a successful call to the the API server.
    /// - Parameter response: The raw response data received by the client
    /// - Returns: A `Response` object containing the decoded response.
    func handleResponse(_ response: Data) throws -> Response
}
