import ComposableArchitecture

public class SessionStore {
    public private(set) var session: Session?
    
    public init() { }
    
    public func update(_ session: Session?) {
        self.session = session
    }
}

extension SessionStore {
    static let live = SessionStore()
}

extension SessionStore: DependencyKey {
    public static let liveValue = SessionStore.live
}

extension DependencyValues {
  var sessionStore: SessionStore {
    get { self[SessionStore.self] }
    set { self[SessionStore.self] = newValue }
  }
}
