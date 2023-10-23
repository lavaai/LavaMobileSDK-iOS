// swift-tools-version:5.3
import PackageDescription

let version = "2.0.15"
let checksum = "8735352a180697f8e470f21cfa5d0fc6282f8df01a8bc310f2d3a6d7acbf4980"

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