// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "DomainKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DomainKit",
            targets: ["DomainKit"]
        ),
    ],
    dependencies: [
        .package(name: "Toolbox", path: "../Toolbox")
    ],
    targets: [
        .target(
            name: "DomainKit",
            dependencies: ["Toolbox"]
        ),
        .testTarget(
            name: "DomainKitTests",
            dependencies: ["DomainKit"]
        ),
    ]
)
