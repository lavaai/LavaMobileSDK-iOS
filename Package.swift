// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "219f2ae8fc742d9d4e14f42d2a1ea1e1a0ff1f968e37ca7cc8d91fd86acd5768"

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