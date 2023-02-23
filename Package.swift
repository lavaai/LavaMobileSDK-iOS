// swift-tools-version:5.3
import PackageDescription

let version = "2.0.13"
let checksum = "f0b25597db758c0b60cdff5bb23e1bc9052dd9b06ff704a52f7b8fbdf1a44449"

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