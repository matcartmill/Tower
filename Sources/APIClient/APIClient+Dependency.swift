import ComposableArchitecture
import Foundation
import JWT
import NetworkEnvironment

extension APIClient: DependencyKey {
    public static let liveValue = Self(
        exchange: { identity in
            return request(path: "v1", "auth", "exchange") { request in
                request.jsonBody(identity)
                request.contentTypeJSON()
                request.httpMethod = "POST"
            }
        },
        logout: { token in
            request(path: "v1", "auth", "logout") { request in
                request.authorize(with: token)
            }
        },
        me: { token in
            request(path: "v1", "me") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
            }
        },
        updateMe: { token, user in
            request(path: "v1", "me") { request in
                request.jsonBody(user)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PUT"
            }
        },
        updateAvatar: { token, data in
            request(path: "v1", "me", "avatar") { request in
                request.httpBodyStream = .init(data: data)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PUT"
            }
        },
        myConversations: { token in
            request(path: "v1", "conversations") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        openConversations: { token in
            request(path: "v1", "conversations", "open") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        createConversation: { token, conversation in
            request(path: "v1", "conversations") { request in
                print(conversation)
                request.jsonBody(conversation)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        incomingConversationRequests: { token in
            request(path: "v1", "conversations", "requests", "incoming") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        outgoingConversationRequests: { token in
            request(path: "v1", "conversations", "requests", "outgoing") { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "GET"
            }
        },
        cancelOutgoingRequest: { token, requestId in
            request(path: "v1", "conversations", "requests", "outgoing", requestId.uuidString) { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "DELETE"
            }
        },
        answerIncomingRequest: { token, requestId in
            request(path: "v1", "conversations", "requests", "incoming", requestId.uuidString) { request in
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "PATCH"
            }
        },
        addFriend: { token, userId in
            request(path: "v1", "connections", "add") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        block: { token, userId in
            request(path: "v1", "connections", "block") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        report: { token, userId in
            request(path: "v1", "connections", "block") { request in
                request.jsonBody(userId)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        trackMood: { token, emotion in
            request(path: "v1", "track", "mood") { request in
                request.jsonBody(emotion)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        },
        registerDeviceToken: { token, deviceTokenRequest in
            request(path: "v1", "deviceToken", "register") { request in
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
            return .task {
                await TaskResult {
                    .init(token: "foo")
                }
            }
        },
        logout: { _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        me: { _ in
            return .task {
                await TaskResult {
                    .sender
                }
            }
        },
        updateMe: { _, _ in
            return .task {
                await TaskResult {
                    .sender
                }
            }
        },
        updateAvatar: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        myConversations: { _ in
            return .task {
                await TaskResult { [] }
            }
        },
        openConversations: { _ in
            return .task {
                await TaskResult { .init(items: [], metadata: .init(page: 1, per: 10, total: 10)) }
            }
        },
        createConversation: { _, _ in
            return .task {
                await TaskResult {
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
                }
            }
        },
        incomingConversationRequests: { _ in
            return .task {
                await TaskResult { [] }
            }
        },
        outgoingConversationRequests: { _ in
            return .task {
                await TaskResult { [] }
            }
        },
        cancelOutgoingRequest: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        answerIncomingRequest: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        addFriend: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        block: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        report: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        trackMood: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        },
        registerDeviceToken: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
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
    modify: @escaping (inout URLRequest) -> Void
) -> Effect<TaskResult<T>, Never> {
    let networkEnvironment: NetworkEnvironment = .current
    
    return .task { [networkEnvironment] in
        await TaskResult {
            var components = URLComponents()
            components.scheme = networkEnvironment.apiProtocol
            components.host = networkEnvironment.apiHost
            components.port = networkEnvironment.apiPort
            components.path = "/" + path.joined(separator: "/")
            
            var request = URLRequest(url: components.url!)
            
            modify(&request)
            
            do {
                let value: T = try await URLSession.shared.execute(request)
                return value
            } catch let error {
                throw error
            }
        }
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
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()
