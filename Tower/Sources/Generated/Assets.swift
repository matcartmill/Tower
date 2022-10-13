// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum Colors {
    internal enum Background {
      internal static let base = ColorAsset(name: "colors/background/base")
      internal enum Button {
        internal static let primary = ColorAsset(name: "colors/background/button/primary")
        internal static let primaryDisabled = ColorAsset(name: "colors/background/button/primary_disabled")
        internal static let secondary = ColorAsset(name: "colors/background/button/secondary")
      }
      internal enum Chat {
        internal static let incoming = ColorAsset(name: "colors/background/chat/incoming")
        internal static let outgoing = ColorAsset(name: "colors/background/chat/outgoing")
      }
      internal enum Gradient {
        internal static let blueEnd = ColorAsset(name: "colors/background/gradient/blue_end")
        internal static let blueStart = ColorAsset(name: "colors/background/gradient/blue_start")
        internal static let charcoalEnd = ColorAsset(name: "colors/background/gradient/charcoal_end")
        internal static let charcoalStart = ColorAsset(name: "colors/background/gradient/charcoal_start")
        internal static let coralEnd = ColorAsset(name: "colors/background/gradient/coral_end")
        internal static let coralStart = ColorAsset(name: "colors/background/gradient/coral_start")
        internal static let purpleEnd = ColorAsset(name: "colors/background/gradient/purple_end")
        internal static let purpleStart = ColorAsset(name: "colors/background/gradient/purple_start")
        internal static let tealEnd = ColorAsset(name: "colors/background/gradient/teal_end")
        internal static let tealStart = ColorAsset(name: "colors/background/gradient/teal_start")
        internal static let yellowEnd = ColorAsset(name: "colors/background/gradient/yellow_end")
        internal static let yellowStart = ColorAsset(name: "colors/background/gradient/yellow_start")
      }
      internal enum Paint {
        internal static let black = ColorAsset(name: "colors/background/paint/black")
        internal static let blue = ColorAsset(name: "colors/background/paint/blue")
        internal static let gray = ColorAsset(name: "colors/background/paint/gray")
        internal static let green = ColorAsset(name: "colors/background/paint/green")
        internal static let pink = ColorAsset(name: "colors/background/paint/pink")
        internal static let purple = ColorAsset(name: "colors/background/paint/purple")
        internal static let red = ColorAsset(name: "colors/background/paint/red")
        internal static let steel = ColorAsset(name: "colors/background/paint/steel")
        internal static let teal = ColorAsset(name: "colors/background/paint/teal")
        internal static let yellow = ColorAsset(name: "colors/background/paint/yellow")
      }
      internal static let secondary = ColorAsset(name: "colors/background/secondary")
      internal static let sheet = ColorAsset(name: "colors/background/sheet")
      internal static let tertiary = ColorAsset(name: "colors/background/tertiary")
    }
    internal enum Content {
      internal enum Button {
        internal static let primary = ColorAsset(name: "colors/content/button/primary")
        internal static let primaryDisabled = ColorAsset(name: "colors/content/button/primary_disabled")
        internal static let secondary = ColorAsset(name: "colors/content/button/secondary")
        internal static let secondaryDisabled = ColorAsset(name: "colors/content/button/secondary_disabled")
      }
      internal static let primary = ColorAsset(name: "colors/content/primary")
      internal static let secondary = ColorAsset(name: "colors/content/secondary")
    }
  }
  internal enum Icons {
    internal static let account = ImageAsset(name: "icons/account")
    internal static let arrowDown = ImageAsset(name: "icons/arrow_down")
    internal static let bell = ImageAsset(name: "icons/bell")
    internal static let calendar = ImageAsset(name: "icons/calendar")
    internal static let chatBubble = ImageAsset(name: "icons/chat-bubble")
    internal static let checkCircle = ImageAsset(name: "icons/check-circle")
    internal static let commentAlert = ImageAsset(name: "icons/comment-alert")
    internal static let compose = ImageAsset(name: "icons/compose")
    internal static let conversation = ImageAsset(name: "icons/conversation")
    internal static let crossCircle = ImageAsset(name: "icons/cross-circle")
    internal static let image = ImageAsset(name: "icons/image")
    internal static let lock = ImageAsset(name: "icons/lock")
    internal static let more = ImageAsset(name: "icons/more")
    internal static let notificationIndicator = ImageAsset(name: "icons/notification-indicator")
    internal static let plus = ImageAsset(name: "icons/plus")
    internal static let send = ImageAsset(name: "icons/send")
    internal static let shieldCheck = ImageAsset(name: "icons/shield-check")
    internal static let tag = ImageAsset(name: "icons/tag")
    internal static let task = ImageAsset(name: "icons/task")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
