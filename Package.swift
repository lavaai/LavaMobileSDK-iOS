// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "1e57cf9fc3db38b798b1dc0beb9fc8272b13e893b1cdcc1d93ba36b22f3b6a63"

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