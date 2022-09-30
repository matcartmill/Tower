import Foundation

extension APIOperation {

    /// The default encoder used by an operation
    public var encoder: JSONEncoder { APIClient.encoder }

    /// The default decoder used by an operation
    public var decoder: JSONDecoder { APIClient.decoder }
}

extension APIOperation where Response: Decodable {

    /// Default decoding in cases where `Response` associated type is `Decodable`.
    public func handleResponse(_ response: Data) throws -> Response {
        try decoder.decode(Response.self, from: response)
    }
}

extension APIOperation where Response == String {

    /// Default decoder in cases where `Response` associated type is a `String`.
    /// Always decodes to UTF8.
    public func handleResponse(_ response: Data) throws -> String {
        String(decoding: response, as: UTF8.self)
    }
}

extension APIOperation where Response == Void {

    /// Default decoding  cases where there is no expected response.
    public func handleResponse(_ response: Data) throws { }
}
