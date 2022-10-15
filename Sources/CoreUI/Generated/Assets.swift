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
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public enum Background {
      public static let base = ColorAsset(name: "colors/background/base")
      public enum Button {
        public static let primary = ColorAsset(name: "colors/background/button/primary")
        public static let primaryDisabled = ColorAsset(name: "colors/background/button/primary_disabled")
        public static let secondary = ColorAsset(name: "colors/background/button/secondary")
      }
      public enum Chat {
        public static let incoming = ColorAsset(name: "colors/background/chat/incoming")
        public static let outgoing = ColorAsset(name: "colors/background/chat/outgoing")
      }
      public enum Gradient {
        public static let blueEnd = ColorAsset(name: "colors/background/gradient/blue_end")
        public static let blueStart = ColorAsset(name: "colors/background/gradient/blue_start")
        public static let charcoalEnd = ColorAsset(name: "colors/background/gradient/charcoal_end")
        public static let charcoalStart = ColorAsset(name: "colors/background/gradient/charcoal_start")
        public static let coralEnd = ColorAsset(name: "colors/background/gradient/coral_end")
        public static let coralStart = ColorAsset(name: "colors/background/gradient/coral_start")
        public static let purpleEnd = ColorAsset(name: "colors/background/gradient/purple_end")
        public static let purpleStart = ColorAsset(name: "colors/background/gradient/purple_start")
        public static let tealEnd = ColorAsset(name: "colors/background/gradient/teal_end")
        public static let tealStart = ColorAsset(name: "colors/background/gradient/teal_start")
        public static let yellowEnd = ColorAsset(name: "colors/background/gradient/yellow_end")
        public static let yellowStart = ColorAsset(name: "colors/background/gradient/yellow_start")
      }
      public enum Paint {
        public static let black = ColorAsset(name: "colors/background/paint/black")
        public static let blue = ColorAsset(name: "colors/background/paint/blue")
        public static let gray = ColorAsset(name: "colors/background/paint/gray")
        public static let green = ColorAsset(name: "colors/background/paint/green")
        public static let pink = ColorAsset(name: "colors/background/paint/pink")
        public static let purple = ColorAsset(name: "colors/background/paint/purple")
        public static let red = ColorAsset(name: "colors/background/paint/red")
        public static let steel = ColorAsset(name: "colors/background/paint/steel")
        public static let teal = ColorAsset(name: "colors/background/paint/teal")
        public static let yellow = ColorAsset(name: "colors/background/paint/yellow")
      }
      public static let secondary = ColorAsset(name: "colors/background/secondary")
      public static let sheet = ColorAsset(name: "colors/background/sheet")
      public static let tertiary = ColorAsset(name: "colors/background/tertiary")
    }
    public enum Content {
      public enum Button {
        public static let primary = ColorAsset(name: "colors/content/button/primary")
        public static let primaryDisabled = ColorAsset(name: "colors/content/button/primary_disabled")
        public static let secondary = ColorAsset(name: "colors/content/button/secondary")
        public static let secondaryDisabled = ColorAsset(name: "colors/content/button/secondary_disabled")
      }
      public static let primary = ColorAsset(name: "colors/content/primary")
      public static let secondary = ColorAsset(name: "colors/content/secondary")
    }
  }
  public enum Icons {
    public static let account = ImageAsset(name: "icons/account")
    public static let arrowDown = ImageAsset(name: "icons/arrow_down")
    public static let bell = ImageAsset(name: "icons/bell")
    public static let calendar = ImageAsset(name: "icons/calendar")
    public static let chatBubble = ImageAsset(name: "icons/chat-bubble")
    public static let checkCircle = ImageAsset(name: "icons/check-circle")
    public static let commentAlert = ImageAsset(name: "icons/comment-alert")
    public static let compose = ImageAsset(name: "icons/compose")
    public static let conversation = ImageAsset(name: "icons/conversation")
    public static let crossCircle = ImageAsset(name: "icons/cross-circle")
    public static let image = ImageAsset(name: "icons/image")
    public static let lock = ImageAsset(name: "icons/lock")
    public static let more = ImageAsset(name: "icons/more")
    public static let notificationIndicator = ImageAsset(name: "icons/notification-indicator")
    public static let plus = ImageAsset(name: "icons/plus")
    public static let send = ImageAsset(name: "icons/send")
    public static let shieldCheck = ImageAsset(name: "icons/shield-check")
    public static let tag = ImageAsset(name: "icons/tag")
    public static let task = ImageAsset(name: "icons/task")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
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
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
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
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
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
public extension SwiftUI.Image {
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
