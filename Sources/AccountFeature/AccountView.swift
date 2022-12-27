import ComposableArchitecture
import CoreUI
import ImageUploaderFeature
import SwiftUI

public struct AccountView: View {
    public let store: StoreOf<Account>
    
    public init(store: StoreOf<Account>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 40) {
                VStack(spacing: 12) {
                    if let data = viewStore.localPhotoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        ProfileImage(viewStore.user.avatarUrl)
                            .frame(width: 100, height: 100)
                    }

                    ImageUploaderView(store: store.scope(
                        state: \.imageUploaderState,
                        action: Account.Action.imageUploader
                    )) {
                        Text("Update Avatar")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .font(.caption)
                            .background(Asset.Colors.Background.Button.secondary.swiftUIColor)                        
                            .foregroundColor(Asset.Colors.Content.Button.secondary.swiftUIColor)
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                Asset.Colors.Background.secondary.swiftUIColor
                    .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Settings")
                        .font(.footnote.bold())
                        .foregroundColor(Asset.Colors.Content.secondary.swiftUIColor)
                    
                    Toggle(
                        "Notifications enabled",
                        isOn: viewStore.binding(\.$notificationsEnabled)
                    )
                    .font(.body)
                    
                    Button("Enable Push") {
                        viewStore.send(.enablePush)
                    }
                }
                
                Spacer()
                
                Button(action: { viewStore.send(.logout) }) {
                    Text("Sign out")
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .background(
                Asset.Colors.Background.base.swiftUIColor
                    .ignoresSafeArea()
            )
        }
    }
}
