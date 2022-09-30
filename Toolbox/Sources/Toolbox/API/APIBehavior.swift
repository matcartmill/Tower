import Foundation

/// Can be implemented by a type that wishes to intercept the lifecycle of an operation
public protocol APIBehavior: AnyObject {

    /// Intercepts an operation before it is performed
    ///
    /// Allows for mutation of the request to perform.
    ///
    /// - Parameters:
    ///   - client: The vessel client that is performing the operation
    ///   - operation: The operation performed by the client
    ///   - request: The request that will be performed by the client
    /// - Returns: An optionally mutated request to be performed by the client
    func client<T: APIOperation>(_ client: APIClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest

    /// Intercepts an operation every time a response is received
    /// - Parameters:
    ///   - client: The vessel client that is performing the operation
    ///   - operation: The operation performed by the client
    ///   - request: The request that has been performed by the client
    ///   - response: The reponse received by the client
    func client<T: APIOperation>(_ client: APIClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws

    /// Intercepts an operation after it has been completed
    /// - Parameters:
    ///   - client: The vessel client that is performing the operation
    ///   - operation: The operation performed by the client
    ///   - request: The request that has been performed by the client
    ///   - response: The reponse received by the client
    func client<T: APIOperation>(_ client: APIClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws
}

// MARK: - Default Behaviours
extension APIBehavior {
    public func client<T: APIOperation>(_ client: APIClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest { request }
    public func client<T: APIOperation>(_ client: APIClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws { }
    public func client<T: APIOperation>(_ client: APIClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws { }
}
