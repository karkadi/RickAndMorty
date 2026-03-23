// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SnapshotMacros",
    platforms: [
        .macOS(.v13),       // ← minimum for Swift macros
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
    ],
    products: [
        .library(
            name: "SnapshotMacros",
            targets: ["SnapshotMacros"]
        ),
        .executable(
            name: "SnapshotMacrosClient",
            targets: ["SnapshotMacrosClient"]
        ),
    ],
    dependencies: [
        // ✅ Use a real tag — aligned with Swift 6.2 / Xcode 16
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
    ],
    targets: [
        .macro(
            name: "SnapshotMacroImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros",  package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "SnapshotMacros",
            dependencies: [
                .target(name: "SnapshotMacroImpl")  // ← local target, not .product
            ]
        ),
        .executableTarget(
            name: "SnapshotMacrosClient",
            dependencies: ["SnapshotMacros"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
