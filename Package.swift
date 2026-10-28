// swift-tools-version:5.3
import PackageDescription

let version = "2.0.35-test1"
let checksum = "3d5fdebcafaa536c9bb7c69dcb914bdaa2e384fd59bbf1afa9c34e25b433fe56"

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