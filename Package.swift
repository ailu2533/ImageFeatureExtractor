// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageFeatureExtractor",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImageFeatureExtractor",
            targets: ["ImageFeatureExtractor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ailu2533/CustomColor.git", branch: "main"),
        .package(url: "https://github.com/ailu2533/LemonUtils.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ImageFeatureExtractor",
            dependencies: [
                .product(name: "CustomColor", package: "CustomColor"),
                .product(name: "LemonUtils", package: "LemonUtils")

            ],
            resources: [
                .process("Resources")
            ]
        ),
//        .testTarget(
//            name: "ImageFeatureExtractorTests",
//            dependencies: ["ImageFeatureExtractor"]
//        ),
    ]
)
