// swift-tools-version:5.3
import PackageDescription

let version = "2.0.33"
let checksum = "3f3a973fa0bc12e7bf6318f048ee339ad271ccce4a5c32e23f7e26ed3fde21e1"

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