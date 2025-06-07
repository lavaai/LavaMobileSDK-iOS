// swift-tools-version:5.3
import PackageDescription

let version = "2.0.30-rc3"
let checksum = "c8d22a35910f2d8ee28e79ec98f2a429bf11721da985b4bd7afc9a26a196982e"

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