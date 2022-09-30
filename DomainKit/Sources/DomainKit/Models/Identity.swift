import Toolbox

public struct Identity: Equatable {
    public let id: Identifier<Self>
    public let jwt: String
    
    public init(id: Identifier<Self>, jwt: String) {
        self.id = id
        self.jwt = jwt
    }
}
