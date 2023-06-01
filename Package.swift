// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "57aa5feb9c51d1f587ce87393a5afb42094ec5dfb4e2dc890808820f2fd3dadb"

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