// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "bcfa3d672374de44a83dc74d8aa7c3fee77b102c6aa63872bd113443408ee7c6"

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