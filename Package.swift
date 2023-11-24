// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "df6299bdc04af82c86c033ecf71b69585fc0d85a8e09a7bced1ff42c32ce787c"

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