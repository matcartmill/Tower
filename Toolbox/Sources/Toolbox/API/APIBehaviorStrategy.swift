import Foundation

/// A type used when performing operations or modifying behaviors that exposes a function to mutate an array of behaviors
public struct APIBehaviorStrategy {

    /// A function that takes an array of behavior, optionally mutates it, and returns a new array of behaviors
    var include: ([APIBehavior]) -> [APIBehavior]
}

extension APIBehaviorStrategy {

    /// A preset that does not mutate the array of behaviors
    public static var all: APIBehaviorStrategy { .init { $0 } }

    /// A preset that excludes all behaviors
    public static var none: APIBehaviorStrategy { .init { _ in [] } }

    /// A preset that excludes a certain type of behaviors
    /// - Parameter behaviors: The type of behaviors to exclude
    /// - Returns: A mutated array excluding all behaviors of the given type
    public static func exclude(_ behaviors: [APIBehavior.Type]) -> APIBehaviorStrategy {
        .init { existing in
            existing.filter { behavior in
                !behaviors.contains { type(of: behavior) == $0 }
            }
        }
    }

    /// A preset that excludes specific instances of behaviors
    /// - Parameter behaviors: The instances of behaviors to exclude
    /// - Returns: A mutated array excluding all given instances of behaviors
    public static func exclude(_ behaviors: [APIBehavior]) -> APIBehaviorStrategy {
        .init { existing in
            existing.filter { behavior in
                !behaviors.contains { behavior === $0 }
            }
        }
    }

    /// A preset that includes only behaviors of the given type
    /// - Parameter behaviors: The only type of behavior to include
    /// - Returns: A mutated array containg only the given types of behaviors
    public static func only(_ behaviors: [APIBehavior.Type]) -> APIBehaviorStrategy {
        .init { existing in
            existing.filter { behavior in
                behaviors.contains { type(of: behavior) == $0 }
            }
        }
    }

    /// A preset that includes only the given instances of behaviors
    /// - Parameter behaviors: The only instances of behaviors to include
    /// - Returns: A mutated array containing only the given instances of behaviors
    public static func only(_ behaviors: [APIBehavior]) -> APIBehaviorStrategy {
        .init { _ in behaviors }
    }

    /// A preset that appends behaviors at the end of the input behaviors
    /// - Parameter behaviors: The instances to append at the end
    /// - Returns: A mutated array with appended behaviors
    public static func appending(_ behaviors: [APIBehavior]) -> APIBehaviorStrategy {
        .init { $0 + behaviors }
    }

    /// A preset that prepends behaviors at the beginning of the input behaviors
    /// - Parameter behaviors: The instaces to prepend at the beginning
    /// - Returns: A mutated array with prepended behaviors
    public static func prepending(_ behaviors: [APIBehavior]) -> APIBehaviorStrategy {
        .init { behaviors + $0 }
    }

    /// A preset that replaces the first instance of a given type with another instance
    ///
    /// Appends the new instance if no instances of the given type is found.
    ///
    /// - Parameters:
    ///   - type: The type of behavior to replace
    ///   - behavior: The instance to replace the one found
    /// - Returns: A mutated array containing the new instance
    public static func replaceFirst<T: APIBehavior>(_ type: T.Type = T.self, with behavior: T) -> APIBehaviorStrategy {
        .init { behaviors in

            guard let index = behaviors.firstIndex(where: { $0 is T }) else {
                return behaviors + [behavior]
            }

            var updated = behaviors
            updated[index] = behavior

            return updated
        }
    }
}
