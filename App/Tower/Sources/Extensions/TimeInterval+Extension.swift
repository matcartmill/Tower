import Foundation

extension TimeInterval {
    public var minutes: Self { self * 60 }
    public var hours: Self { self * 60 * 60 }
    public var days: Self { self * 60 * 60 * 24 }
}
