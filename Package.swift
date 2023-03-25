// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "6d8e54f5ac303fe579a747bce95e8662032ef77cafa3819c83ebf37f7804dbb8"

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