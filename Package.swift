// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "0af066e68cfcb4a1564ab320b3401b63fde398af5573b150de68af0e7f30fc06"

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