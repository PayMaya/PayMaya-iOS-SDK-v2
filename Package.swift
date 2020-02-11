import PackageDescription

let package = Package(
    name: "PayMayaSDK",
    products: [
        .library(name: "PayMayaSDK", targets: ["PayMayaSDK"])
    ],
    targets: [
        .target(name: "PayMayaSDK", path: "PayMayaSDK"),
        .testTarget(name: "PayMayaSDKTests", path: "PayMayaSDK")
    ]
)
