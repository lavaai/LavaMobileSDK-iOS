// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17-dev10"
let checksum = "1ef0dfc25565cc129fc04f0549ff9ccc5f213495fc5d25747b58ecdf1b383e56"

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