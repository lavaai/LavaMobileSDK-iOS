// swift-tools-version:5.3
import PackageDescription

let version = "2.0.17"
let checksum = "e78fc916dea95bd72fb6028af019f3fdb747b7ff426bd9bde09e3dd1ca17b29d"

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