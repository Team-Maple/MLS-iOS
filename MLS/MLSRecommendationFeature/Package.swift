// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MLSRecommendationFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Interface: Presentation 팩토리 프로토콜
        .library(
            name: "MLSRecommendationFeatureInterface",
            targets: ["MLSRecommendationFeatureInterface"]
        ),
        // Feature: Presentation + Domain + Data 구현체
        .library(
            name: "MLSRecommendationFeature",
            targets: ["MLSRecommendationFeature"]
        ),
        // Testing: 단위 테스트나 Example 앱에서 사용될 Mock 데이터를 제공하는 모듈
        .library(
            name: "MLSRecommendationFeatureTesting",
            targets: ["MLSRecommendationFeatureTesting"]
        )
    ],
    dependencies: [
        .package(path: "../MLSCore"),
        .package(path: "../MLSDesignSystem"),
        .package(path: "../MLSBookmarkFeature"),
        .package(path: "../MLSDictionaryFeature"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        // Interface 모듈 (Presentation 팩토리 프로토콜)
        .target(
            name: "MLSRecommendationFeatureInterface",
            dependencies: [
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "RxSwift", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Feature 모듈 (Presentation + Domain + Data 구현체)
        .target(
            name: "MLSRecommendationFeature",
            dependencies: [
                "MLSRecommendationFeatureInterface",
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "MLSBookmarkFeatureInterface", package: "MLSBookmarkFeature"),
                .product(name: "MLSDictionaryFeatureInterface", package: "MLSDictionaryFeature"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxKeyboard", package: "RxKeyboard"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Testing 모듈 (Mock 객체)
        .target(
            name: "MLSRecommendationFeatureTesting",
            dependencies: [
                "MLSRecommendationFeatureInterface",
                .product(name: "RxSwift", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Tests 모듈
        .testTarget(
            name: "MLSRecommendationFeatureTests",
            dependencies: [
                "MLSRecommendationFeature",
                "MLSRecommendationFeatureInterface",
                "MLSRecommendationFeatureTesting",
                .product(name: "RxBlocking", package: "RxSwift")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)
