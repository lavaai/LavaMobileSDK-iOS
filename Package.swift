// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "9634e1b47ae158efb7cce8458bb0c8462d40c8a0cc5ed5db1b8da491fc7c4a5a"

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