import Foundation
import os.log

/// A behavior that can log the requests and responses that are performed and received by the client
public class LoggingAPIBehavior: APIBehavior {

    /// A function that is given a string representation of the request and response
    private let logger: (String) -> Void

    /// Initializes a new instance
    /// - Parameter logger: A function that is given a string representation of the request and response
    public init(logger: ((String) -> Void)? = nil) {
        self.logger = logger ?? { os_log("%s", log: .api, $0) }
    }

    /// Calls the logger function with a string representation of the request and response
    /// - Parameters:
    ///   - client: The vessel client that owns this behavior
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    public func client<T: APIOperation>(_ client: APIClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws {
        guard let url = request.url?.absoluteString, let httpMethod = request.httpMethod else { return }

        var requestLines: [String] = ["curl -v -X \(httpMethod)", url]

        let headers = request.allHTTPHeaderFields
            .or([:])
            .sorted { $0.key < $1.key }
            .map { "-H '\($0.key): \($0.value)'" }

        requestLines.append(contentsOf: headers)

        if let data = request.httpBody, let string = String(data: data, encoding: .utf8) {
            requestLines.append("-d '\(string)'")
        }

        var responseLines: [String] = []

        if let response = response.1 as? HTTPURLResponse {
            responseLines.append("Status: \(response.statusCode)")

            let headers = (response.allHeaderFields as? [String: String])
                .or([:])
                .sorted { $0.key < $1.key }
                .map { "Header: '\($0.key): \($0.value)'" }

            responseLines.append(contentsOf: headers)
        }

        if let string = String(data: response.0, encoding: .utf8) {
            responseLines.append("Body: " + string)
        }

        let logString = """
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        \(String(describing: T.self))
        REQUEST:
        \(requestLines.joined(separator: " \\\n"))
        RESPONSE:
        \(responseLines.joined(separator: "\n"))
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """

        logger(logString)
    }
}
