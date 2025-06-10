// swift-tools-version:5.3
import PackageDescription

let version = "2.0.30-rc4"
let checksum = "bb0acfc8ea371a4282637ab760813e4092c91bb342037b75e0c63db0b6e8f826"

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