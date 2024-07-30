// swift-tools-version:5.3
import PackageDescription

let version = "2.0.21"
let checksum = "2de6c4b3ef3431f91229c7828b7cbd6b2cad673058c1c6a7ab3c37a76d7747b0"

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