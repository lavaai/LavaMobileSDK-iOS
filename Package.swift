// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "eae3b7249dd4b07ad1b1bd3ae06d27059d5be3c6523d2fceb4bf5c93292f03ca"

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