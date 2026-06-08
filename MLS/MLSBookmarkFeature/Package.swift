// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MLSBookmarkFeature",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MLSBookmarkFeatureInterface",
            targets: ["MLSBookmarkFeatureInterface"]
        ),
        .library(
            name: "MLSBookmarkFeature",
            targets: ["MLSBookmarkFeature"]
        ),
        .library(
            name: "MLSBookmarkFeatureTesting",
            targets: ["MLSBookmarkFeatureTesting"]
        )
    ],
    dependencies: [
        .package(path: "../MLSAppFeature"),
        .package(path: "../MLSAuthFeature"),
        .package(path: "../MLSCore"),
        .package(path: "../MLSDesignSystem"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        // Interface 모듈 (팩토리/리포지토리 프로토콜 + 엔티티)
        .target(
            name: "MLSBookmarkFeatureInterface",
            dependencies: [
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Feature 모듈 (Presentation + Domain + Data 구현체)
        .target(
            name: "MLSBookmarkFeature",
            dependencies: [
                "MLSBookmarkFeatureInterface",
                .product(name: "MLSAppFeatureInterface", package: "MLSAppFeature"),
                .product(name: "MLSAuthFeatureInterface", package: "MLSAuthFeature"),
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Testing 모듈 (Mock + Stub 객체)
        .target(
            name: "MLSBookmarkFeatureTesting",
            dependencies: [
                "MLSBookmarkFeatureInterface",
                .product(name: "MLSAuthFeatureInterface", package: "MLSAuthFeature"),
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Tests 모듈
        .testTarget(
            name: "MLSBookmarkFeatureTests",
            dependencies: [
                "MLSBookmarkFeature",
                "MLSBookmarkFeatureInterface",
                "MLSBookmarkFeatureTesting",
                .product(name: "RxBlocking", package: "RxSwift")
            ]
        )
    ]
)
