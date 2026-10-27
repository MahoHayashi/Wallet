// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "PassGenerator",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/pass-builder", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "PassGenerator",
            dependencies: [
                .product(name: "PassBuilder", package: "pass-builder")
            ]
        )
    ]
)
