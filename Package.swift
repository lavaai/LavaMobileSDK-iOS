// swift-tools-version:5.3
import PackageDescription

let version = "2.0.23.dev1"
let checksum = "f541fcfc766140fddd0a65103cd963cb110703b4e94fe7f6ed871bca4c749063"

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