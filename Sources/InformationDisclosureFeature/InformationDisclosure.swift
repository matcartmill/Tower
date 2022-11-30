import ComposableArchitecture

public struct InformationDisclosure: ReducerProtocol {
    public enum Context: Equatable {
        case author
        case participant
        
        public var title: String {
            switch self {
            case .author:
                return "Accept this participant request?"
                
            case .participant:
                return "Join this conversation?"
            }
        }
        
        public var description: String {
            switch self {
            case .author:
                return "By accepting this request your username and avatar will be shared with the participant."
                
            case .participant:
                return "By requesting to join this conversation your username, avatar, and account rating will be shared with the conversation author."
            }
        }
    }
    
    public struct State: Equatable {
        public let context: Context
        
        public init(context: Context) {
            self.context = context
        }
    }
    
    public enum Action {
        case next
        case cancel
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
