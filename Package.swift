// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Deasciifier",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Deasciifier",
            targets: ["Deasciifier"]),
    ],
    dependencies: [
        .package(name: "MorphologicalAnalysis", url: "https://github.com/StarlangSoftware/TurkishMorphologicalAnalysis-Swift.git", .exact("1.0.2")),         .package(name: "NGram", url: "https://github.com/StarlangSoftware/NGram-Swift.git", .exact("1.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Deasciifier",
            dependencies: ["MorphologicalAnalysis", "NGram"]),
        .testTarget(
            name: "DeasciifierTests",
            dependencies: ["Deasciifier"]),
    ]
)