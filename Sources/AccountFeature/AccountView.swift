import ComposableArchitecture
import CoreUI
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
                    VStack {
                        Text("Mat Cartmill")
                            .font(.title3.bold())
                        Text(verbatim: "mat.cartmill@gmail.com")
                            .font(.body)
                    }
                    .foregroundColor(Asset.Colors.Content.primary.swiftUIColor)
                    
                    Button(action: {}) {
                        Text("Update")
                            .font(.caption)
                            .foregroundColor(Asset.Colors.Content.Button.secondary.swiftUIColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Asset.Colors.Background.Button.secondary.swiftUIColor)
                    .clipShape(Capsule())
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
                }
                
                Spacer()
                
                Button(action: {}) {
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
