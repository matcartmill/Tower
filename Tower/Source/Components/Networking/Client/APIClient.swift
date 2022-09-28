import Foundation

public final class APIClient {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let session: URLSession
    
    init(
        configuration: URLSessionConfiguration = .default,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.session = .init(configuration: configuration)
    }
    
    func perform<T: APIOperation>(_ operation: T) async throws -> T.Response {
        let (data, response) = try await session.data(for: .init(operation.createRequest()))
        
        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            Range(200...299).contains(statusCode)
        else { throw HTTPError.statusCodeFailure }
        
        return try operation.handleResponse(data)
    }
}

extension APIClient {
    public static var defaultJSONDecoder = JSONDecoder()
    public static var defaultJSONEncoder = JSONEncoder()
}
