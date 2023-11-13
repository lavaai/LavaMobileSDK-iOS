// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "38286e0d63437d472fa3670eae0f18b6ac46208dd5bf1dda2adb6e696bfa8a11"

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