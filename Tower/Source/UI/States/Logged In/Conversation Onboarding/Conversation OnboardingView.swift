import ComposableArchitecture
import SwiftUI

public struct ConversationOnboardingView: View {
    private let store: ConversationOnboardingStore
    
    public init(store: ConversationOnboardingStore) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                
            }
            .font(.headline)
            .foregroundColor(Color("colors/content/primary"))
        }
    }
}
