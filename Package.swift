// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "6f61c68d0b99d6f6080c515cc3f7a0a0fb9ed27f575155a676811f44143c8e13"

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