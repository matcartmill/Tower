import ComposableArchitecture
import SwiftUI

public struct ConversationOnboardingView: View {
    private let store: StoreOf<ConversationOnboarding>
    
    public init(store: StoreOf<ConversationOnboarding>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView<EmptyView>(
                image: Image("icons/comment-alert"),
                title: "Before you post...",
                details: "If you need immediate mental health support please dial your local health crisis number.",
                primaryAction: .init(
                    title: "I understand",
                    execute: { }
                ),
                secondaryAction: .init(
                    title: "Cancel",
                    execute: { }
                ),
                canProceed: true
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color("colors/background/sheet").ignoresSafeArea())
            .foregroundColor(Color("colors/content/primary"))
        }
    }
}
