// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "02d83533da58a44b508134b3cee5c0d3eaef8d678a8ddde5e181e081667fe3eb"

let package = Package(
    name: "LavaSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LavaSDK",
            targets: ["LavaSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "LavaSDK",
            url: "https://raw.githubusercontent.com/lavaai/LavaSDK-iOS-SP/\(version)/LavaSDK.xcframework.zip",
            checksum: checksum
        )
    ]
)