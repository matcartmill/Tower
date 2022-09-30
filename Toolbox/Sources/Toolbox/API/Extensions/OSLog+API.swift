import os.log

extension OSLog {
    /// A default logger for the `LoggingBehavior` if none is provided
    static let api = OSLog(
        subsystem: "tower.toolbox.api",
        category: "NETWORKING ☁️"
    )
}
