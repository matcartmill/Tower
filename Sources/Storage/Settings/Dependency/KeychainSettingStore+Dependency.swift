import ComposableArchitecture

extension KeychainSettingStore: DependencyKey {
    public static let liveValue: KeychainSettingStore = .init(
        settings: .init(
            service: "io.towerapp.secure-settings",
            accessGroup: .shared(teamId: "756N86X6Q9"),
            accessibility: .afterFirstUnlockThisDeviceOnly
        )
    )
}

extension DependencyValues {
    public var keychain: KeychainSettingStore {
        get { self[KeychainSettingStore.self] }
        set { self[KeychainSettingStore.self] = newValue }
    }
}
