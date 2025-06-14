// swift-tools-version:5.3
import PackageDescription

let version = "2.0.31-rc1"
let checksum = "08a5434e41721506bc76072b82d5024d55fdcb03f40fbb86bfe4706e7685c4b8"

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