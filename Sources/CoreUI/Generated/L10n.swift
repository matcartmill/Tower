// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Onboarding {
    public enum Avatar {
      /// Adding a profile picture puts a face to your name, but we understand if you'd rather be private.
      public static let details = L10n.tr("Localizable", "Onboarding.Avatar.details", fallback: "Adding a profile picture puts a face to your name, but we understand if you'd rather be private.")
      /// Want to spruce up your profile a bit?
      public static let title = L10n.tr("Localizable", "Onboarding.Avatar.title", fallback: "Want to spruce up your profile a bit?")
      public enum Button {
        /// Choose a Photo
        public static let title = L10n.tr("Localizable", "Onboarding.Avatar.Button.title", fallback: "Choose a Photo")
      }
    }
    public enum Button {
      /// Finish up
      public static let finishUp = L10n.tr("Localizable", "Onboarding.Button.finishUp", fallback: "Finish up")
      /// Next
      public static let next = L10n.tr("Localizable", "Onboarding.Button.next", fallback: "Next")
    }
    public enum Notifications {
      /// Adding a profile picture puts a face to your name, but we understand if you'd rather be  private.
      public static let details = L10n.tr("Localizable", "Onboarding.Notifications.details", fallback: "Adding a profile picture puts a face to your name, but we understand if you'd rather be  private.")
      /// Want to spruce up your profile a bit?
      public static let title = L10n.tr("Localizable", "Onboarding.Notifications.title", fallback: "Want to spruce up your profile a bit?")
      public enum Button {
        /// Enable Push Notifications
        public static let title = L10n.tr("Localizable", "Onboarding.Notifications.Button.title", fallback: "Enable Push Notifications")
      }
    }
    public enum Username {
      /// Your unique username will be used as an alias when chatting with others using the platform.
      public static let details = L10n.tr("Localizable", "Onboarding.Username.details", fallback: "Your unique username will be used as an alias when chatting with others using the platform.")
      /// What should we call you?
      public static let title = L10n.tr("Localizable", "Onboarding.Username.title", fallback: "What should we call you?")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
