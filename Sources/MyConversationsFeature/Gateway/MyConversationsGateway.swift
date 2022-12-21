import Combine
import Foundation
import JWT
import Models
import NetworkEnvironment


public class MyConversationsGateway {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let environment: NetworkEnvironment
    private let session: URLSession
    private let jwt: () -> JWT
    private var connection: URLSessionWebSocketTask?
    private var continuation: AsyncStream<Action>.Continuation?
    private var timer: AnyPublisher<Date, Never>
    private var timerCancellable: AnyCancellable?
    
    public init(
        session: URLSession = .shared,
        environment: NetworkEnvironment = .current,
        jwt: @escaping () -> JWT,
        timer: AnyPublisher<Date, Never> = Timer.publish(
            every: 10,
            on: .main,
            in: .common
        ).autoconnect().eraseToAnyPublisher(),
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
    
    public func open() throws -> AsyncStream<Action> {
        guard
            let url = URL(string: "\(environment.socketProtocol)://\(environment.apiHost)/v1/conversations/stream")
        else { throw Error.invalidUrl }
        
        let stream = AsyncStream<Action> { [weak self] continuation in
            self?.continuation = continuation
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwt().token)", forHTTPHeaderField: "Authorization")
        
        connection = session.webSocketTask(with: request)
        configureCallbacks()
        connection?.resume()
        configureTimer()
        
        return stream
    }
    
    public func close() {
        timerCancellable?.cancel()
        continuation?.finish()
        connection?.cancel(with: .goingAway, reason: nil)
    }
    
    // MARK: - Private
    
    private func configureCallbacks() {
        connection?.receive(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(.data(let data)):
                do {
                    let event = try self.decoder.decode(Event.self, from: data)
                    
                    switch event.action {
                    case .newConversation:
                        let conversation = try event.payload.to(Conversation.self)
                        self.continuation?.yield(.addConversation(conversation))
                        
                    default:
                        break
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                
            case .success(.string(let string)):
                print("Received a string value of \(string), but we are not expecting any string values here")
                
            case .success:
                print("Received an unhandled success case")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.configureCallbacks()
        })
    }
    
    private func configureTimer() {
        timerCancellable?.cancel()
        timerCancellable = timer.sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            
            self.connection?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.close()
                }
            })
        })
    }
}
