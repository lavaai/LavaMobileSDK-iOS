// swift-tools-version:5.3
import PackageDescription

let version = "2.0.35-test2"
let checksum = "4798ff465e15c7e8aab83accd215b88330d04ae7750999a8410ebe4ab9114156"

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