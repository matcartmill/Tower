import ComposableArchitecture
import SwiftUI

public struct AccountView: View {
    let store: AccountStore
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Toggle(
                        "Notifications enabled",
                        isOn: viewStore.binding(\.$notificationsEnabled)
                    )
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("colors/background/base").ignoresSafeArea())
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(store: .init(
            initialState: .init(user: .sender),
            reducer: accountReducer,
            environment: .live
        ))
    }
}
