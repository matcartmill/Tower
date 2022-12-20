import ComposableArchitecture
import Foundation
import JWT
import Models
import NetworkEnvironment

extension APIClient: DependencyKey {
    public static let liveValue = Self(
        exchange: { identity in
            try await request(path: "v1", "auth", "exchange") { request in
                request.jsonBody(identity)
                request.contentTypeJSON()
                request.httpMethod = "POST"
            }
        },
        logout: { token in
            try await request(path: "v1", "auth", "logout") { request in
                request.authorize(with: token)
            }
        },
        me: { token in
            try await request(path: "v1", "me") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
            }
        },
        updateMe: { token, user in
            try await request(path: "v1", "me") { request in
                request.jsonBody(user)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PUT"
            }
        },
        updateAvatar: { token, data in
            try await request(path: "v1", "me", "avatar") { request in
                request.httpBodyStream = .init(data: data)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PUT"
            }
        },
        myConversations: { token in
            try await request(path: "v1", "conversations") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        openConversations: { token, pageInfo in
            try await request(
                path: "v1", "conversations", "open",
                queryItems: [
                    URLQueryItem(name: "page", value: "\(pageInfo.page)"),
                    URLQueryItem(name: "per", value: "\(pageInfo.per)")
                ]
            ) { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        createConversation: { token, conversation in
            try await request(path: "v1", "conversations") { request in
                request.jsonBody(conversation)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        sendMessage: { token, message, conversationId in
            try await request(path: "v1", "conversations", conversationId.rawValue, "messages") { request in
                request.jsonBody(SendMessageRequest(content: message))
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        incomingConversationRequests: { token in
            try await request(path: "v1", "conversations", "requests", "incoming") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        outgoingConversationRequests: { token in
            try await request(path: "v1", "conversations", "requests", "outgoing") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        sendOutgoingRequest: { token, conversationId in
            try await request(path: "v1", "conversations", conversationId.rawValue, "request") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        cancelOutgoingRequest: { token, requestId in
            try await request(path: "v1", "conversations", "requests", "outgoing", requestId.rawValue) { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "DELETE"
            }
        },
        answerIncomingRequest: { token, requestId in
            try await request(path: "v1", "conversations", "requests", "incoming", requestId.rawValue) { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PATCH"
            }
        },
        addFriend: { token, userId in
            try await request(path: "v1", "connections", "add") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        block: { token, userId in
            try await request(path: "v1", "connections", "block") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        report: { token, userId in
            try await request(path: "v1", "connections", "block") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        trackMood: { token, emotion in
            try await request(path: "v1", "track", "mood") { request in
                request.jsonBody(emotion)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        registerDeviceToken: { token, deviceTokenRequest in
            try await request(path: "v1", "deviceToken", "register") { request in
                request.jsonBody(deviceTokenRequest)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        }
    )
}

extension APIClient {
    public static let mock = Self(
        exchange: { _ in
            .init(token: "foo")
        },
        logout: { _ in
            return
        },
        me: { _ in
            .sender
        },
        updateMe: { _, _ in
            .sender
        },
        updateAvatar: { _, _ in
            return
        },
        myConversations: { _ in
            []
        },
        openConversations: { _, _ in
            .init(items: [], metadata: .init(page: 1, per: 10, total: 10))
        },
        createConversation: { _, _ in
            .init(
                id: .init(),
                author: .init(
                    username: "Foo",
                    avatar: nil,
                    rating: nil,
                    joined: Date()
                ),
                participant: nil,
                messages: [],
                createdAt: Date(),
                updatedAt: Date()
            )
        },
        sendMessage: { _, _, _ in
            return
        },
        incomingConversationRequests: { _ in
            []
        },
        outgoingConversationRequests: { _ in
            []
        },
        sendOutgoingRequest: { _, _ in
            .init(summary: .init(
                id: .init(),
                summary: "",
                createdAt: Date(),
                updatedAt: Date()
            ))
        },
        cancelOutgoingRequest: { _, _ in
            return
        },
        answerIncomingRequest: { _, _ in
            return
        },
        addFriend: { _, _ in
            return
        },
        block: { _, _ in
            return
        },
        report: { _, _ in
            return
        },
        trackMood: { _, _ in
            return
        },
        registerDeviceToken: { _, _ in
            return
        }
    )
}

extension DependencyValues {
  public var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

private func request<T: Decodable>(
    path: String...,
    queryItems: [URLQueryItem] = [],
    modify: @escaping (inout URLRequest) -> Void
) async throws -> T {
    let networkEnvironment: NetworkEnvironment = .current

    var components = URLComponents()
    components.scheme = networkEnvironment.apiProtocol
    components.host = networkEnvironment.apiHost
    components.port = networkEnvironment.apiPort
    components.path = "/" + path.joined(separator: "/")
    components.queryItems = []
    
    queryItems.forEach { components.queryItems?.append($0) }
    
    var request = URLRequest(url: components.url!)
    
    modify(&request)
    
    do {
        let value: T = try await URLSession.shared.execute(request)
        return value
    } catch let error {
        throw error
    }
}

private func request(
    path: String...,
    queryItems: [URLQueryItem] = [],
    modify: @escaping (inout URLRequest) -> Void
) async throws {
    let networkEnvironment: NetworkEnvironment = .current

    var components = URLComponents()
    components.scheme = networkEnvironment.apiProtocol
    components.host = networkEnvironment.apiHost
    components.port = networkEnvironment.apiPort
    components.path = "/" + path.joined(separator: "/")
    components.queryItems = []
    
    queryItems.forEach { components.queryItems?.append($0) }
    
    var request = URLRequest(url: components.url!)
    
    modify(&request)
    
    do {
        try await URLSession.shared.execute(request)
    } catch let error {
        throw error
    }
}

private extension URLRequest {
    mutating func authorize(with jwt: JWT) {
        print(jwt.token)
        self.setValue("Bearer \(jwt.token)", forHTTPHeaderField: "Authorization")
    }
    mutating func contentTypeJSON() {
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    mutating func jsonBody<T: Encodable>(_ content: T) {
        encoder.dateEncodingStrategy = .iso8601
        self.httpBody = try? encoder.encode(content)
    }
}

private extension URLSession {
    func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        decoder.dateDecodingStrategy = .iso8601
        
        let response = try await self.data(for: request)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? decoder.decode(APIError.self, from: response.0) {
                throw apiError
            }
            
            throw APIError.invalidStatusCode
        }
        
        do {
            let parsed = try decoder.decode(T.self, from: response.0)
            return parsed
        } catch let error {
            throw error
        }
    }
    
    func execute(_ request: URLRequest) async throws {
        decoder.dateDecodingStrategy = .iso8601
        
        let response = try await self.data(for: request)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? decoder.decode(APIError.self, from: response.0) {
                throw apiError
            }
            
            throw APIError.invalidStatusCode
        }
    }
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()
