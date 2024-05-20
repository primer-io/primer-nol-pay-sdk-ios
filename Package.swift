// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PrimerNolPaySDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PrimerNolPaySDK",
            targets: [
                "PrimerNolPaySDK",
                "TransitSDKFramework"
            ]
        )
    ],
    targets: [
        .target(
            name: "PrimerNolPaySDK",
            path: "Sources/PrimerNolPaySDK"
        ),
        .binaryTarget(
            name: "TransitSDKFramework",
            path: "Sources/Frameworks/TransitSDK.xcframework"
        )
    ],
    swiftLanguageVersions: [.v5]
)
