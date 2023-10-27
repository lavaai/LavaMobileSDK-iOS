// swift-tools-version:5.3
import PackageDescription

let version = "2.0.16"
let checksum = "142087afedf4407a98bd70bd58f09cd52b4b4a70ed8ad9ebaabdb8754755217c"

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