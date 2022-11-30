import ComposableArchitecture
import CoreUI
import SwiftUI

public struct ConversationDisclosureView: View {
    private let store: StoreOf<ConversationDisclosure>
    
    public init(store: StoreOf<ConversationDisclosure>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView<EmptyView>(
                image: Asset.Icons.commentAlert.swiftUIImage,
                title: "Before you post...",
                details: "If you need immediate mental health support please dial your local health crisis number.",
                primaryAction: .init(
                    title: "I understand",
                    execute: { viewStore.send(.next) }
                ),
                secondaryAction: .init(
                    title: "Cancel",
                    execute: { viewStore.send(.cancel) }
                ),
                canProceed: true
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .themedBackground()
            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
        }
    }
}
