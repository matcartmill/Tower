import Foundation

// MARK: - Default Values
extension Optional {

    /// A convenience function that returns
    /// - Parameter value: The default value
    /// - Returns: A default value if the optional is nil
    public func or(_ value: Wrapped) -> Wrapped {
        switch self {
        case .none: return value
        case .some(let existing): return existing
        }
    }
}

// MARK: - Nullability
extension Optional {

    /// A convenience property that return `true` if the optional is nil, `false` otherwise
    public var isNil: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }

    /// A convenience property that return `false` if the optional is nil, `true` otherwise
    public var isNotNil: Bool { !isNil }
}
