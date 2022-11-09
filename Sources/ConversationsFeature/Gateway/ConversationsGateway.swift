import Combine
import Foundation
import JWT
import Models
import NetworkEnvironment

public protocol MyConversationsGateway {
    func open() throws -> AsyncStream<[Conversation]>
    func close()
}

public class WebSocketMyConversationsGateway: MyConversationsGateway {
    public enum Error: Swift.Error {
        case invalidUrl
    }
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let environment: NetworkEnvironment
    private let session: URLSession
    private let jwt: () -> JWT
    private var connection: URLSessionWebSocketTask?
    private var continuation: AsyncStream<[Conversation]>.Continuation?
    private var timer: AnyPublisher<Date, Never>
    private var timerCancellable: AnyCancellable?
    
    public init(
        session: URLSession = .shared,
        environment: NetworkEnvironment = .current,
        jwt: @escaping () -> JWT,
        timer: AnyPublisher<Date, Never> = Timer.publish(every: 3, on: .current, in: .default).autoconnect().eraseToAnyPublisher(),
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.session = session
        self.environment = environment
        self.jwt = jwt
        self.decoder = decoder
        self.encoder = encoder
        self.timer = timer
        
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
    }
    
    public func open() throws -> AsyncStream<[Conversation]> {
        guard let url = URL(string: "\(environment.socketProtocol)://\(environment.apiHost)/conversations/stream") else {
            throw Error.invalidUrl
        }
        
        let stream = AsyncStream<[Conversation]> { [weak self] continuation in
            self?.continuation = continuation
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwt().token)", forHTTPHeaderField: "Authorization")
        
        connection = session.webSocketTask(with: request)
        connection?.receive(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(.data(let data)):
                print("Received updated conversations")
                
            case .success(.string(let string)):
                print("Received a string value of \(string), but we are not expecting any string values here")
                
            case .success:
                print("Received an unhandled success case")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        timerCancellable = timer.sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            
            self.connection?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.close()
                }
            })
        })
        
        return stream
    }
    
    public func close() {
        timerCancellable?.cancel()
        continuation?.finish()
        connection?.cancel(with: .goingAway, reason: nil)
    }
}

