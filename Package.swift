// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "8b59e86d0ec5b440f516292ecc93b30a0d09aa0ec4e8a059ff5e61ec6fae6bdd"

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