// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLSDictionaryFeature",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MLSDictionaryFeatureInterface",
            targets: ["MLSDictionaryFeatureInterface"]
        ),
        .library(
            name: "MLSDictionaryFeature",
            targets: ["MLSDictionaryFeature"]
        ),
        .library(
            name: "MLSDictionaryFeatureTesting",
            targets: ["MLSDictionaryFeatureTesting"]
        )
    ],
    dependencies: [
        .package(path: "../MLSAuthFeature"),
        .package(path: "../MLSMyPageFeature"),
        .package(path: "../MLSCore"),
        .package(path: "../MLSDesignSystem"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        // Interface
        .target(
            name: "MLSDictionaryFeatureInterface",
            dependencies: [
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "RxSwift", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Feature
        .target(
            name: "MLSDictionaryFeature",
            dependencies: [
                "MLSDictionaryFeatureInterface",
                .product(name: "MLSAuthFeatureInterface", package: "MLSAuthFeature"),
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "MLSMyPageFeatureInterface", package: "MLSMyPageFeature"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxKeyboard", package: "RxKeyboard"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Mock
        .target(
            name: "MLSDictionaryFeatureTesting",
            dependencies: [
                "MLSDictionaryFeatureInterface",
                .product(name: "MLSAuthFeatureInterface",package: "MLSAuthFeature"),
                .product(name: "MLSMyPageFeatureInterface",package: "MLSMyPageFeature"),
                .product(name: "RxSwift", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Tests
        .testTarget(
            name: "MLSDictionaryFeatureTests",
            dependencies: [
                "MLSDictionaryFeature",
                "MLSDictionaryFeatureInterface",
                "MLSDictionaryFeatureTesting",
                .product(name: "MLSAuthFeatureInterface", package: "MLSAuthFeature"),
                .product(name: "MLSAuthFeatureTesting", package: "MLSAuthFeature"),
                .product(name: "RxBlocking", package: "RxSwift")
            ],
        )
    ]
)
