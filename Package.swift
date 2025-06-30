// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Mastermind",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "Mastermind",
            dependencies: [],
            path: "Sources"
        )
    ]
)