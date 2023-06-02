// swift-tools-version:5.3
import PackageDescription

let version = "2.0.14"
let checksum = "21b8de9bef8f6874d211e7d180e41adfffb3926d8942ad6c40993ef5aa1c24dd"

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