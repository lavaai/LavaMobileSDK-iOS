// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "9b91e0930d29c8ca82417a7d6421ed0a56e6b94e26e80fe1981653b7c5a891d8"

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