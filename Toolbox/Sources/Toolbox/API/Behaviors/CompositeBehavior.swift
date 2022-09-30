import Foundation

/// Composes an ordered array of behaviors
class CompositeBehavior: APIBehavior {

    /// An ordered array of behaviors to compose
    let behaviors: [APIBehavior]

    /// Initializes a new composite behavior
    /// - Parameter behaviors: The behavior that the composite behavior composes
    init(behaviors: [APIBehavior]) {
        self.behaviors = behaviors
    }

    /// Composes the request returned by each behavior
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the behaviors can modify
    /// - Returns: The composed request of all behaviors
    func client<T: APIOperation>(_ client: APIClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        var composed = request

        for behavior in behaviors {
            composed = try await behavior.client(client, operationWillBegin: operation, request: composed)
        }

        return composed
    }

    /// Forwards the received operation to all behaviors
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    func client<T: APIOperation>(_ client: APIClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws {
        for behavior in behaviors {
            try await behavior.client(client, operationReceived: operation, request: request, response: response)
        }
    }

    /// Forwards the completed operation to all behaviors
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    func client<T: APIOperation>(_ client: APIClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws {
        for behavior in behaviors {
            try await behavior.client(client, operationCompleted: operation, request: request, response: response)
        }
    }
}
