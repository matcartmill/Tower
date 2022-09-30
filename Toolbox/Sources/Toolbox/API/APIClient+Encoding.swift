import Foundation

extension APIClient {

    /// The default encoder used by the client
    public static var encoder: JSONEncoder = .init()

    /// The default decoder used by the client
    public static var decoder: JSONDecoder = .init()
}
