// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "c10c2a36021ce3eec99be6673cce3811dec3b156a8c78bb1103f3fd77a6a75bd"

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