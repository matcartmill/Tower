import Foundation
import Starscream

protocol RemoteEventChannel {
    var onEvent: ((WebSocketEvent) -> Void)? { get set }
    
    func connect()
    func disconnect(closeCode: UInt16)
    func write(string: String, completion: (() -> ())?)
    func write(stringData: Data, completion: (() -> ())?)
    func write(data: Data, completion: (() -> ())?)
    func write(ping: Data, completion: (() -> ())?)
    func write(pong: Data, completion: (() -> ())?)
}

public enum RemoteEventChannelEvent {
    case connected([String: String])
    case disconnected(String, UInt16)
    case text(String)
    case binary(Data)
    case pong(Data?)
    case ping(Data?)
    case error(Error?)
    case viabilityChanged(Bool)
    case reconnectSuggested(Bool)
    case cancelled
}

extension RemoteEventChannelEvent {
    init(_ event: WebSocketEvent) {
        switch event {
        case .connected(let dict):
            self = .connected(dict)
            
        case .disconnected(let reason, let closeCode):
            self = .disconnected(reason, closeCode)
            
        case .text(let value):
            self = .text(value)
            
        case .binary(let data):
            self = .binary(data)
            
        case .ping(let data):
            self = .ping(data)
            
        case .pong(let data):
            self = .pong(data)
            
        case .error(let error):
            self = .error(error)
            
        case .viabilityChanged(let changed):
            self = .viabilityChanged(changed)
            
        case .reconnectSuggested(let suggested):
            self = .reconnectSuggested(suggested)
            
        case .cancelled:
            self = .cancelled
        }
    }
}

extension WebSocket: RemoteEventChannel { }
