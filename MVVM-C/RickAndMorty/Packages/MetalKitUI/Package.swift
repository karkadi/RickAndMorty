// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MetalKitUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MetalKitUI",
            targets: ["MetalKitUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MetalKitUI",
            dependencies: [],
            resources: [
                .process("Shaders")
            ]
        ),
    ]
)
