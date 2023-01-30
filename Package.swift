// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "dee9498e8920b837e0f7764fdc15dfc938f81dc734411c17ab550a0502fb7208"

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