// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "language-detector",
    platforms: [
        .macOS(.v13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LanguageDetector",
            targets: ["LanguageDetector"]),
    ],
    dependencies: [
    .package(
      url: "https://github.com/apple/swift-collections.git", 
      .upToNextMinor(from: "1.0.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LanguageDetector",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
            resources: [
                .process("Resources/subsets")
            ]),
        .testTarget(name: "LanguageDetectorTests",
                    dependencies: ["LanguageDetector"])
    ]
)
