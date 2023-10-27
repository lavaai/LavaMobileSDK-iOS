// swift-tools-version:5.3
import PackageDescription

let version = "2.0.16"
let checksum = "f36b338ce99817145abdf304636c53f96ff691e48554e1fe13cbb36089cf1c58"

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