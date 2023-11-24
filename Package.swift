// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "2e9bcd092a1bb0e3f70076f52930cd0fd915afa83e2dca5daee51b2af0d5da34"

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