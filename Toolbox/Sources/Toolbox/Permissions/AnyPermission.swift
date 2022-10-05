/// Defines the possible outcomes of a Permission
///
/// - unknown: The permission has not been decided yet.
/// - authorized: The permission has been granted.
/// - denied: The permissions has been denied.
public enum PermissionState: String, Equatable, Codable {
    case unknown, authorized, denied
}

public enum PermissionError: Error {
    case permissionDenied(PermissionType.Type)
}

/// Encapsulates the state and requesting of a single permission
public class AnyPermission {
    public typealias RequestComplete = (PermissionState) -> Void

    public let name: String
    public let status: () -> PermissionState

    /// Request access to this permission,
    /// the completion handler returns with the resulting `PermissionState`.
    ///
    /// - Note: The completion handler is called on the main thread.
    public let requestAccess: (@escaping RequestComplete) -> Void

    public init(name: String, status: @escaping () -> PermissionState, requestAccess: @escaping (@escaping RequestComplete) -> Void) {
        self.name = name
        self.status = status
        self.requestAccess = requestAccess
    }
}

/// Protocol used to tag _what_ permission we are granting
public protocol PermissionType { }

/// Encapsulates the state and requesting of a single permission restricted to a specific `PermissionType`
public class Permission<PermissionType>: AnyPermission { }

