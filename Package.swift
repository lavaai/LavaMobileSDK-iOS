// swift-tools-version:5.3
import PackageDescription

let version = "2.0.30-rc"
let checksum = "d3a2173811e8c5dde804973d6bf3f226199dd219079e6538a311b5e65a4aaa96"

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