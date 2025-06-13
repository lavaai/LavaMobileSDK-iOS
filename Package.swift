// swift-tools-version:5.3
import PackageDescription

let version = "2.0.30"
let checksum = "ff88f0294e63acf2bb84e2925b8c828acd04b501ca9de94c3baa0a2e6a4ecbc0"

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