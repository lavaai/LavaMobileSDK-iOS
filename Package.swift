// swift-tools-version:5.3
import PackageDescription

let version = "2.0.8"
let checksum = "a009b8ff1817e26834fcd3c19c0a8e9bc83e9262258df728daed4621ab91d439"

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