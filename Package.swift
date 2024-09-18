// swift-tools-version:5.3
import PackageDescription

let version = "2.0.27"
let checksum = "ca2b52f44831f01439b82bde0fe2a00a1f0adff6f232d6048eb9ce900b8c78ce"

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