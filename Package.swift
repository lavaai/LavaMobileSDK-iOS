// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "7380b645c8fb6fd7a568dc813d2a631c54e1ede4af8f666e0ac5d40d69daace5"

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