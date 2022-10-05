import ComposableArchitecture
import SwiftUI

public struct ConversationOnboardingView: View {
    private let store: ConversationOnboardingStore
    
    public init(store: ConversationOnboardingStore) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 32) {
                OnboardingIconView(image: Image("icons/comment-alert"))
                
                Text("Before you post...")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("If you need immediate mental health support please dial your local health crisis number.")
                    .multilineTextAlignment(.center)
                
                Button("I understand") { }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 200)
                
                Button("Cancel") { }
                    .buttonStyle(SecondaryButtonStyle())
                    .frame(width: 200)
            }
            .padding()
            .foregroundColor(Color("colors/content/primary"))
        }
    }
}
