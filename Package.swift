// swift-tools-version:5.3
import PackageDescription

let version = "2.0.34-test1"
let checksum = "b6c0403389fdb2c5a3d9e727f873e94672127a432064f61346cf3724124d3bd7"

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