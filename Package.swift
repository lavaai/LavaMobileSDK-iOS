// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "dc4765f8e9d2561b5f7859793cff20e4bafdab877792dbba3f3bf1b6ba74b788"

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