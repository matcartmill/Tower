// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Toolbox",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Toolbox",
            targets: ["Toolbox"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Toolbox",
            dependencies: []
        ),
        .testTarget(
            name: "ToolboxTests",
            dependencies: ["Toolbox"]
        ),
    ]
)
