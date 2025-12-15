// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "im-swift",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "IMSDK",
            targets: ["IMSDKSupport"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "IMSDK",
            path: "IMSDK/Frameworks/IMSDK.xcframework"
        ),
        .target(
            name: "IMSDKSupport",
            dependencies: ["IMSDK"],
            linkerSettings: [
                .linkedLibrary("xml2"),
                .linkedLibrary("expat"),
                .linkedLibrary("z")
            ]
        ),
        .testTarget(
            name: "im-swiftTests",
            dependencies: ["IMSDKSupport"],
            resources: [
                .process("Res")
            ]
        )
    ]
)
