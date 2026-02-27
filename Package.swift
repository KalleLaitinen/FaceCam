// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "FaceCam",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "FaceCam",
            path: "Sources/FaceCam"
        )
    ]
)
