// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "ca86fd7a895c51eb6ad79f6aba13a5dedad25cc3647726420d75d0c62c221d2d"

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