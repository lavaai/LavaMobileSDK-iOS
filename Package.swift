// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "252b7dbe94f2eebaa24f4b1e56c6f38c5ca0c4f3178ecd15cc4cf7d9b8a2b8c1"

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
            url: "https://raw.githubusercontent.com/lavaai/LavaMobileSDK-iOS/\(version)/LavaSDK.xcframework.zip",
            checksum: checksum
        )
    ]
)