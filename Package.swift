// swift-tools-version:5.7
import Foundation
import PackageDescription

var package = Package(
    name: "Tower",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Components
        .library(name: "AnyCodable", targets: ["AnyCodable"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "Identifier", targets: ["Identifier"]),
        .library(name: "JWT", targets: ["JWT"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "NetworkEnvironment", targets: ["NetworkEnvironment"]),
        .library(name: "Permissions", targets: ["Permissions"]),
        .library(name: "RemoteNotificationsClient", targets: ["RemoteNotificationsClient"]),
        .library(name: "Session", targets: ["Session"]),
        .library(name: "UserNotificationsClient", targets: ["UserNotificationsClient"]),
        .library(name: "WebSockets", targets: ["WebSockets"]),
        
        // Features
        .library(name: "AccountFeature", targets: ["AccountFeature"]),
        .library(name: "AppDelegateFeature", targets: ["AppDelegateFeature"]),
        .library(name: "AppLoadingFeature", targets: ["AppLoadingFeature"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "CalendarFeature", targets: ["CalendarFeature"]),
        .library(name: "ComposeFeature", targets: ["ComposeFeature"]),
        .library(name: "ConversationFeature", targets: ["ConversationFeature"]),
        .library(name: "ConversationOnboardingFeature", targets: ["ConversationOnboardingFeature"]),
        .library(name: "ConversationsFeature", targets: ["ConversationsFeature"]),
        .library(name: "LoggedInFeature", targets: ["LoggedInFeature"]),
        .library(name: "MyConversationsFeature", targets: ["MyConversationsFeature"]),
        .library(name: "NotificationsFeature", targets: ["NotificationsFeature"]),
        .library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
        .library(name: "OpenConversationsFeature", targets: ["OpenConversationsFeature"]),
        .library(name: "RootFeature", targets: ["RootFeature"]),
        .library(name: "TrackingFeature", targets: ["TrackingFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
        .package(url: "https://github.com/daltoniam/Starscream", from: "4.0.0")
    ],
    targets: [
        // Components
        .target(
            name: "AnyCodable",
            dependencies: []
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "NetworkEnvironment",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CoreUI",
            dependencies: ["Models"],
            resources: [.process("Resources/")]
        ),
        .target(name: "Identifier"),
        .target(
            name: "Identity",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(name: "JWT"),
        .target(
            name: "Models",
            dependencies: ["Identifier"]
        ),
        .target(
            name: "NetworkEnvironment",
            dependencies: []
        ),
        .target(
            name: "Permissions",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "RemoteNotificationsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Session",
            dependencies: [
                "JWT",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "UserNotificationsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "WebSockets",
            dependencies: [
                "Starscream",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        
        // Features
        .target(
            name: "AccountFeature",
            dependencies: [
                "APIClient",
                "CoreUI",
                "Models",
                "Permissions",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppDelegateFeature",
            dependencies: [
                "APIClient",
                "Session",
                "UserNotificationsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppLoadingFeature",
            dependencies: [
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AuthFeature",
            dependencies: [
                "APIClient",
                "CoreUI",
                "Identity",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CalendarFeature",
            dependencies: [
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposeFeature",
            dependencies: [
                "CoreUI",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ConversationFeature",
            dependencies: [
                "AnyCodable",
                "CoreUI",
                "Models",
                "NetworkEnvironment",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ConversationOnboardingFeature",
            dependencies: [
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ConversationsFeature",
            dependencies: [
                "APIClient",
                "AccountFeature",
                "ComposeFeature",
                "ConversationFeature",
                "ConversationOnboardingFeature",
                "CoreUI",
                "Models",
                "MyConversationsFeature",
                "OpenConversationsFeature",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "LoggedInFeature",
            dependencies: [
                "APIClient",
                "ConversationsFeature",
                "NotificationsFeature",
                "TrackingFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "MyConversationsFeature",
            dependencies: [
                "APIClient",
                "ConversationFeature",
                "CoreUI",
                "Models",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "NotificationsFeature",
            dependencies: [
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: [
                "APIClient",
                "CoreUI",
                "Permissions",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OpenConversationsFeature",
            dependencies: [
                "APIClient",
                "CoreUI",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "RootFeature",
            dependencies: [
                "AppLoadingFeature",
                "AuthFeature",
                "LoggedInFeature",
                "OnboardingFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "TrackingFeature",
            dependencies: [
                "APIClient",
                "CalendarFeature",
                "CoreUI",
                "Models",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        )
    ]
)
