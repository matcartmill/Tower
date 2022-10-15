import ComposableArchitecture
import Foundation

extension APIClient: DependencyKey {
    public static let liveValue = Self(
        exchange: { identity in
            return request(path: "v1", "auth", "exchange") { request in
                request.jsonBody(identity)
                request.contentTypeJSON()
                request.httpMethod = "POST"
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
        associateDeviceToken: { token, deviceToken in
            request(path: "v1", "connections", "block") { request in
                request.jsonBody(deviceToken)
                request.contentTypeJSON()
                request.authorize(with: token)
                request.httpMethod = "POST"
            }
        }
    )
}

extension APIClient {
    static let mock = Self(
        exchange: { _ in
            return .task {
                await TaskResult {
                    .init(token: "foo")
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
        associateDeviceToken: { _, _ in
            return .task {
                await TaskResult {
                    .init(success: true, error: nil)
                }
            }
        }
    )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

private func request<T: Decodable>(
    path: String...,
    modify: @escaping (inout URLRequest) -> Void
) -> Effect<TaskResult<T>, Never> {
    return .task {
        await TaskResult {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "0.0.0.0"
            components.port = 8080
            components.path = "/" + path.joined(separator: "/")
            
            var request = URLRequest(url: components.url!)
            
            modify(&request)
            
            do {
                let value: T = try await URLSession.shared.execute(request)
                return value
            } catch let error {
                throw APIError.remote(error)
            }
        }
    }
}

private extension URLRequest {
    mutating func authorize(with jwt: JWT) {
        self.setValue("Bearer \(jwt.token)", forHTTPHeaderField: "Authorization")
    }
    mutating func contentTypeJSON() {
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    mutating func jsonBody<T: Encodable>(_ content: T) {
        self.httpBody = try? encoder.encode(content)
    }
}

private extension URLSession {
    func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        let response = try await self.data(for: request)
        return try decoder.decode(T.self, from: response.0)
    }
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()
