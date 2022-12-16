// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APOD",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Repository", targets: ["Repository"]),
        .library(name: "RemoteStore", targets: ["RemoteStore"]),
        .library(name: "Screen", targets: ["ListingPictures"])
    ],
    dependencies: [
    ],
    targets: [
        //Domain
        .target(name: "Domain"),
        //Repository
        .target(
            name: "Repository",
            dependencies: ["Domain"]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
        //RemoteStore
        .target(
            name: "RemoteStore",
            dependencies: ["Domain"]),
        .testTarget(
            name: "RemoteStoreTests",
            dependencies: ["RemoteStore"],
            resources: [.copy("Stub")]),
        //ListingPictures
        .target(name: "ListingPictures",
                dependencies: ["Domain"]),
        .testTarget(name: "ListingPicturesTests",
                   dependencies: ["ListingPictures"])
    ]
)
