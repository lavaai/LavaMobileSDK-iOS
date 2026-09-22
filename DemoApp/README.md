# DemoApp

This repo is the DemoApp for LavaSDK. For local development it links the sibling `SDK-iOS` project instead of a published xcframework.

## Requirements

* Xcode 13.2 and above
* Swift 5.5

## Working with the LavaSDK source code

DemoApp is set up as a subproject of the local `SDK-iOS` checkout when the two repos sit next to each other:

```
lavaai/
  SDK-iOS/LavaSDK.xcodeproj
  LavaMobileSDK-iOS/DemoApp/DemoApp.xcodeproj
```

`DemoApp.xcodeproj` references `../../SDK-iOS/LavaSDK.xcodeproj` and embeds `LavaSDK.framework` in the DemoApp and DemoAppSecure targets.

To restore the published binary instead, remove the `LavaSDK.xcodeproj` subproject and add `LavaSDK.xcframework` back under Frameworks, Libraries and Embedded Content.

## Building

* Download and install latest Xcode

* Run the following commands to install cocaopods and to checkout the dependencies of DemoApp:

## lava-service.json
This file is located in DemoApp/DemoApp and its content will be either replaced by GitHub workflow or the developer with appropriate values.

