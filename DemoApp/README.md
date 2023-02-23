# DemoApp

This repo is the DemoApp for LavaSDK. It already contains the compatible LavaSDK.xcframework and ready for building and running.

## Requirements

* Xcode 13.2 and above
* Swift 5.5

## Working with the LavaSDK source code

To work directly with the LavaSDK source code, we need to add LavaSDK project into DemoApp project as a subproject with following steps:
1. Remove the LavaSDK.xcframework from the DemoApp project.
2. Drag and drop the Lava.xcodeproj into the DemoApp project.
3. Under General tab > Frameworks, Libraries and Embedded Content in targets DemoApp and DemoAppSecure of DemoApp project, we need to add the LavaSDK.framework.
4. Clean (Cmd + Shift + K) and build the project.

## Building

* Download and install latest Xcode

* Run the following commands to install cocaopods and to checkout the dependencies of DemoApp:

## lava-service.json
This file is located in DemoApp/DemoApp and its content will be either replaced by GitHub workflow or the developer with appropriate values.

