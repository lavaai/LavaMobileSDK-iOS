// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "18b52dd3ca23068757cd4d00dbeaf4307e99f7a29a7b60c73fd7db3adc254eee"

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