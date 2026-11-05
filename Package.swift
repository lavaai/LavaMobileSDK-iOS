// swift-tools-version:5.3
import PackageDescription

let version = "2.0.35"
let checksum = "010d5418901bf9f1dae20feaebb9fe3b05e1fb2e989889d986ebb7fe6624232e"

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