// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "4456a5746871eea7124754f757da5e980b6be075007061dda8fe7c81457b7d3c"

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