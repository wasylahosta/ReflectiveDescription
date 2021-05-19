// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReflectiveDescription",
    products: [
        .library(
            name: "ReflectiveDescription",
            targets: ["ReflectiveDescription"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ReflectiveDescription",
            dependencies: []),
        .testTarget(
            name: "ReflectiveDescriptionTests",
            dependencies: ["ReflectiveDescription"]),
    ]
)
