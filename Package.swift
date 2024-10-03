// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "postmancol2Code",
    platforms: [
        .macOS(.v10_15)  // Ensure the platform version supports Swift ArgumentParser
    ],
    dependencies: [
        // Adding ArgumentParser dependency
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .executableTarget(
            name: "postmancol2Code",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
    ]
)
