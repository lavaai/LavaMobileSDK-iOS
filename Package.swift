// swift-tools-version:5.3
import PackageDescription

let version = "2.0.15"
let checksum = "dba5c66e67050ad104a2d4cb569258f7d3110bd6bef819d29b501f2d31f7dc04"

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