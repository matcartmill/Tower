import ComposableArchitecture
import PhotosUI
import SwiftUI

public struct ImageUploaderView<Content: View>: View {
    private let store: StoreOf<ImageUploader>
    private let content: () -> Content
    
    public init(store: StoreOf<ImageUploader>, content: @escaping () -> Content) {
        self.store = store
        self.content = content
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            PhotosPicker(
                selection: viewStore.binding(\.$photoItem),
                matching: .images
            ) {
                content()
            }
        }
    }
}
