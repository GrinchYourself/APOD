// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APOD",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "RemoteStore", targets: ["RemoteStore"]),
    ],
    dependencies: [
    ],
    targets: [
        //RemoteStore
        .target(
            name: "RemoteStore",
            dependencies: []),
        .testTarget(
            name: "RemoteStoreTests",
            dependencies: ["RemoteStore"],
            resources: [.copy("Stub")])
    ]
)
