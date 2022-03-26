// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwordRPC",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "SwordRPC",
            targets: ["SwordRPC"]
        ),
    ],
    dependencies: [
        // UNIX sockets, packet serialization
        .package(url: "https://github.com/apple/swift-nio", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "SwordRPC",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ]
        ),
    ]
)
