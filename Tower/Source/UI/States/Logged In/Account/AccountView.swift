import ComposableArchitecture
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
                            .foregroundColor(Color("colors/content/primary"))
                        Text(verbatim: "mat.cartmill@gmail.com")
                            .font(.body)
                            .foregroundColor(Color("colors/content/secondary"))
                    }
                    Button(action: {}) {
                        Text("Update")
                            .font(.caption)
                            .foregroundColor(Color("colors/content/button/secondary"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color("colors/background/button/secondary"))
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                Color("colors/background/secondary")
                    .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Settings")
                        .font(.footnote.bold())
                        .foregroundColor(Color("colors/content/secondary"))
                    
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
            .background(Color("colors/background/base").ignoresSafeArea())
        }
    }
}
