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
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "Identity", targets: ["Identity"]),
        .library(name: "JWT", targets: ["JWT"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "NetworkEnvironment", targets: ["NetworkEnvironment"]),
        .library(name: "Permissions", targets: ["Permissions"]),
        .library(name: "RemoteNotificationsClient", targets: ["RemoteNotificationsClient"]),
        .library(name: "Session", targets: ["Session"]),
        .library(name: "Storage", targets: ["Storage"]),
        .library(name: "UserNotificationsClient", targets: ["UserNotificationsClient"]),
        
        // Features
        .library(name: "AccountFeature", targets: ["AccountFeature"]),
        .library(name: "AppDelegateFeature", targets: ["AppDelegateFeature"]),
        .library(name: "AppLoadingFeature", targets: ["AppLoadingFeature"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "CalendarFeature", targets: ["CalendarFeature"]),
        .library(name: "ComposeFeature", targets: ["ComposeFeature"]),
        .library(name: "ConversationDisclosureFeature", targets: ["ConversationDisclosureFeature"]),
        .library(name: "ConversationFeature", targets: ["ConversationFeature"]),
        .library(name: "ConversationsFeature", targets: ["ConversationsFeature"]),
        .library(name: "ImageUploaderFeature", targets: ["ImageUploaderFeature"]),
        .library(name: "IncomingRequestsFeature", targets: ["IncomingRequestsFeature"]),
        .library(name: "InformationDisclosureFeature", targets: ["InformationDisclosureFeature"]),
        .library(name: "LoggedInFeature", targets: ["LoggedInFeature"]),
        .library(name: "MyConversationsFeature", targets: ["MyConversationsFeature"]),
        .library(name: "NotificationsFeature", targets: ["NotificationsFeature"]),
        .library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
        .library(name: "OpenConversationsFeature", targets: ["OpenConversationsFeature"]),
        .library(name: "OutgoingRequestsFeature", targets: ["OutgoingRequestsFeature"]),
        .library(name: "RootFeature", targets: ["RootFeature"]),
        .library(name: "SignInFeature", targets: ["SignInFeature"]),
        .library(name: "TrackingFeature", targets: ["TrackingFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0")
    ],
    targets: [
        // Components
        .target(
            name: "APIClient",
            dependencies: [
                "Identity",
                "NetworkEnvironment",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(name: "Core"),
        .target(
            name: "CoreUI",
            dependencies: ["Models"],
            resources: [.process("Resources/")]
        ),
        .target(
            name: "Identity",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(name: "JWT"),
        .target(
            name: "Models",
            dependencies: ["Core"]
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
            name: "Storage",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "UserNotificationsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        
        // Features
        .target(
            name: "AccountFeature",
            dependencies: [
                "APIClient",
                "CoreUI",
                "ImageUploaderFeature",
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
                "AuthFeature",
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AuthFeature",
            dependencies: [
                "APIClient",
                "Identity",
                "Session",
                "Storage",
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
            name: "ConversationDisclosureFeature",
            dependencies: [
                "CoreUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ConversationFeature",
            dependencies: [
                "APIClient",
                "Core",
                "CoreUI",
                "Models",
                "NetworkEnvironment",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ConversationsFeature",
            dependencies: [
                "APIClient",
                "AccountFeature",
                "ComposeFeature",
                "ConversationDisclosureFeature",
                "ConversationFeature",
                "Core",
                "CoreUI",
                "IncomingRequestsFeature",
                "InformationDisclosureFeature",
                "Models",
                "MyConversationsFeature",
                "OpenConversationsFeature",
                "OutgoingRequestsFeature",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ImageUploaderFeature",
            dependencies: [
                "APIClient",
                "Models",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "IncomingRequestsFeature",
            dependencies: [
                "APIClient",
                "Models",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "InformationDisclosureFeature",
            dependencies: [
                "CoreUI",
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
                "ConversationFeature",
                "CoreUI",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OutgoingRequestsFeature",
            dependencies: [
                "APIClient",
                "Models",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "RootFeature",
            dependencies: [
                "AppLoadingFeature",
                "ConversationsFeature",
                "OnboardingFeature",
                "SignInFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SignInFeature",
            dependencies: [
                "AuthFeature",
                "CoreUI",
                "Session",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
