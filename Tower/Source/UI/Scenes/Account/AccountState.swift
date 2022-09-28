import ComposableArchitecture

public struct AccountState: Equatable {
    public var user: User
    @BindableState public var notificationsEnabled = true
}
