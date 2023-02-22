// swift-tools-version:5.3
import PackageDescription

let version = "2.0.13"
let checksum = "dbcc1dbd2626806a6a074cc286b2cd64cace6b2bf814e71879f7c5b070df4737"

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
            url: "https://raw.githubusercontent.com/lavaai/LavaSDK-iOS-SP/\(version)/LavaSDK.xcframework.zip",
            checksum: checksum
        )
    ]
)