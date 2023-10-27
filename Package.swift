// swift-tools-version:5.3
import PackageDescription

let version = "2.0.15"
let checksum = "b4cc35e6db1c724ca2c6d268b8d66d216ef21bcfe2fc6780f01fd9c7acd0e8a3"

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