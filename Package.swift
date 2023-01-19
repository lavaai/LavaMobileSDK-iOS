// swift-tools-version:5.3
import PackageDescription

let version = "2.0.8"
let checksum = "e1b743a8eb2bf0370fe54239d2751397aac4d3ee3d14bda31d0825b59f51ba50"

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