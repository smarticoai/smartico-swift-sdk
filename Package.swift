// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SmarticoPublicAPI",
    // macOS is here so `swift build` runs on the host and the
    // parity tool is a plain executable; the SDK imports no UIKit or WebKit.
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SmarticoPublicAPI", targets: ["SmarticoPublicAPI"]),
    ],
    targets: [
        .target(
            name: "SmarticoPublicAPI",
            path: "Sources/SmarticoPublicAPI"
        ),
        // The parity capture tool — the Swift form of Kotlin's separate
        // `src/parity` source set. A target, not a product: consumers of the
        // library never see it.
        .executableTarget(
            name: "ParityDump",
            dependencies: ["SmarticoPublicAPI"],
            path: "Tools/ParityDump"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
