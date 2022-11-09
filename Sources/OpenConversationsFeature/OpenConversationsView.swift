import ComposableArchitecture
import SwiftUI

public struct OpenConversationsView: View {
    public let store: StoreOf<OpenConversations>
    
    public init(store: StoreOf<OpenConversations>) {
        self.store = store
    }
    
    public var body: some View {
        Color.red
    }
}
