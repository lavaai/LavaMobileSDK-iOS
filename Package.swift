// swift-tools-version:5.3
import PackageDescription

let version = "2.0.31"
let checksum = "92357e24812e0b5791f2620af6e27c6d640bfbdf5f7b14fdf7541c8fc762257a"

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