import ComposableArchitecture
import CoreUI
import SwiftUI

public struct InformationDisclosureView: View {
    public let store: StoreOf<InformationDisclosure>
    
    public init(store: StoreOf<InformationDisclosure>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            CalloutView<EmptyView>(
                image: Asset.Icons.commentAlert.swiftUIImage,
                title: viewStore.context.title,
                details: viewStore.context.description,
                primaryAction: .init(
                    title: "Confirm",
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
            .background(
                Asset.Colors.Background.sheet.swiftUIColor
                    .ignoresSafeArea()
            )
            .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
        }
    }
}
