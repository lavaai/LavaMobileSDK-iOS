// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "c18c37fde9bc2b54b6f78c58d0d5dd2b6611c8e4822d7872bcb2daeb46162a10"

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