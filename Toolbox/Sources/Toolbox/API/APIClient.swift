import Foundation
import SwiftUI

/// A client that performs operations
public class APIClient {

    /// The composite behavior that runs the lifecycle of each operation through an ordered array of mutating behaviors
    private var behavior: CompositeBehavior

    /// The `URLSession` used by the client
    private let session: URLSession

    /// Initializes a new client with behaviors and a `URLSession`
    /// - Parameters:
    ///   - behaviors: An ordered array of mutating behaviors
    ///   - session: The `URLSession` to use when performing operations
    public init(behaviors: [APIBehavior], session: URLSession = .shared) {
        self.behavior = CompositeBehavior(behaviors: behaviors)
        self.session = session
    }

    /// Updates the ordered array of behaviors
    /// - Parameter strategy: The strategy to use when updating behaviors
    public func updateBehaviors(with strategy: APIBehaviorStrategy) {
        behavior = .init(behaviors: strategy.include(behavior.behaviors))
    }

    @discardableResult
    /// Performs an operation
    /// - Parameter operation: The operation to perform
    /// - Returns: The response of the operation
    public func perform<T: APIOperation>(_ operation: T) async throws -> T.Response {
        let initial = try operation.makeRequest()

        let request = try await behavior.client(self, operationWillBegin: operation, request: initial)

        let response = try await session.data(for: request)

        try await behavior.client(self, operationReceived: operation, request: request, response: response)

        let result = try operation.handleResponse(response.0)

        try await behavior.client(self, operationCompleted: operation, request: request, response: (response.0, response.1, result))

        return result
    }
}
