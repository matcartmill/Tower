import Foundation

extension Dictionary where Key == String, Value == AnyCodable {
    public func to<T: Decodable>(
        _ type: T.Type,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) throws -> T {
        let data = try encoder.encode(self)
        return try decoder.decode(T.self, from: data)
    }
}
