// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APOD",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "APOD", targets: ["APOD"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "APOD",
            dependencies: []),
        .testTarget(
            name: "APODTests",
            dependencies: ["APOD"]),
    ]
)
