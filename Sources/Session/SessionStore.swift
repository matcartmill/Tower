import ComposableArchitecture

public class SessionStore {
    public private(set) var session: Session?
    
    public init() { }
    
    public func update(_ session: Session?) {
        self.session = session
    }
}
