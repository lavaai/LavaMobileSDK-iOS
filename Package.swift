// swift-tools-version:5.3
import PackageDescription

let version = "2.0.12"
let checksum = "72d077847821ab37c7a238c71e3c3643fa035bf1b95d95474059afd8940c6348"

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