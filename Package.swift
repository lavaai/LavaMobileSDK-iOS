// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "32b825ea51ffaa2ea419e8fd25d393d69d5fbf46d2394e8cb1e100bc768446fc"

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