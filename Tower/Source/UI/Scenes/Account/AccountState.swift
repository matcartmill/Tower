import ComposableArchitecture

public struct AccountState: Equatable {
    public var user: Participant
    @BindableState public var notificationsEnabled = true
}
