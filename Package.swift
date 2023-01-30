// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "8f1a38eb1f0783f292b27abe2f3c9e93cee7381ebb1e2d1344719f29c1a3ff4c"

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