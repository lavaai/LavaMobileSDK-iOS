// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "3f5f795119fde48523eee96934bf75dfdae9d1e01a4fc1508ab2cbfdb32d0815"

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