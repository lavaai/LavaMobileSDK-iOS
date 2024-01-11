// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17-dev10"
let checksum = "a1a052e6fe736ed04dead478c278d5a3123ded3a7c14679f0fb0b186901e4ab0"

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