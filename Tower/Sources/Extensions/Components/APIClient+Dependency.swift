import ComposableArchitecture
import Toolbox

extension APIClient {
    static let live: APIClient = .init(behaviors: [])
}

extension APIClient: DependencyKey {
    public static let liveValue = APIClient.live
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}
