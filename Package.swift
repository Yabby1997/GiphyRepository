// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GiphyRepository",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GiphyRepository",
            targets: ["GiphyRepository"]),
    ],
    dependencies: [
         .package(url: "https://github.com/Yabby1997/GIFPediaService", from: "0.2.2"),
    ],
    targets: [
        .target(
            name: "GiphyRepository",
            dependencies: [
                .product(name: "GIFPediaService", package: "GIFPediaService")
            ]),
    ]
)
