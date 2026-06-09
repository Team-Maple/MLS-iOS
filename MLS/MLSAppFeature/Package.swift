// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLSAppFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Interface: 외부 인터페이스와 모델을 제공하는 모듈
        .library(
            name: "MLSAppFeatureInterface",
            targets: ["MLSAppFeatureInterface"]
        ),
        // Feature: 실제 기능이 구현된 모듈
        .library(
            name: "MLSAppFeature",
            targets: ["MLSAppFeature"]
        ),
        // Testing: 단위 테스트나 Example 앱에서 사용될 Mock 데이터를 제공하는 모듈
        .library(
            name: "MLSAppFeatureTesting",
            targets: ["MLSAppFeatureTesting"]
        )
    ],
    dependencies: [
        .package(path: "../MLSAppFeature"),
        .package(path: "../MLSAuthFeature"),
        .package(path: "../MLSBookmarkFeature"),
        .package(path: "../MLSCore"),
        .package(path: "../MLSDictionaryFeature"),
        .package(path: "../MLSMyPageFeature"),
        .package(path: "../MLSRecommendationFeature"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
    ],
    targets: [
        // Interface 모듈 (도메인 모델 및 프로토콜)
        .target(
            name: "MLSAppFeatureInterface",
            dependencies: []
        ),
        // Feature 모듈 (실제 구현)
        .target(
            name: "MLSAppFeature",
            dependencies: [
                "MLSAppFeatureInterface",
                .product(name: "MLSAuthFeature", package: "MLSAuthFeature"),
                .product(name: "MLSAppFeatureInterface", package: "MLSAppFeature"),
                .product(name: "MLSAuthFeatureInterface", package: "MLSAuthFeature"),
                .product(name: "MLSBookmarkFeature", package: "MLSBookmarkFeature"),
                .product(name: "MLSBookmarkFeatureInterface", package: "MLSBookmarkFeature"),
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDictionaryFeature", package: "MLSDictionaryFeature"),
                .product(name: "MLSDictionaryFeatureInterface", package: "MLSDictionaryFeature"),
                .product(name: "MLSMyPageFeature", package: "MLSMyPageFeature"),
                .product(name: "MLSMyPageFeatureInterface", package: "MLSMyPageFeature"),
                .product(name: "MLSRecommendationFeature", package: "MLSRecommendationFeature"),
                .product(name: "MLSRecommendationFeatureInterface", package: "MLSRecommendationFeature"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        ),
        // Testing 모듈 (Mock 객체)
        .target(
            name: "MLSAppFeatureTesting",
            dependencies: ["MLSAppFeatureInterface"]
        ),
        // Tests 모듈
        .testTarget(
            name: "MLSAppFeatureTests",
            dependencies: [
                "MLSAppFeature",
                "MLSAppFeatureInterface",
                "MLSAppFeatureTesting"
            ]
        )
    ]
)
