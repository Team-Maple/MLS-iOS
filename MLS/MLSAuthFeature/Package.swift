// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MLSAuthFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Interface: Presentation 팩토리 프로토콜
        .library(
            name: "MLSAuthFeatureInterface",
            targets: ["MLSAuthFeatureInterface"]
        ),
        // Feature: Presentation + Domain + Data 구현체
        .library(
            name: "MLSAuthFeature",
            targets: ["MLSAuthFeature"]
        ),
        // Testing: 단위 테스트나 Example 앱에서 사용될 Mock 데이터를 제공하는 모듈
        .library(
            name: "MLSAuthFeatureTesting",
            targets: ["MLSAuthFeatureTesting"]
        ),
    ],
    dependencies: [
        .package(path: "../MLSCore"),
        .package(path: "../MLSDesignSystem"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.22.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
    ],
    targets: [
        // Interface 모듈 (Presentation 팩토리 프로토콜)
        .target(
            name: "MLSAuthFeatureInterface",
            dependencies: [
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Feature 모듈 (Presentation + Domain + Data 구현체)
        .target(
            name: "MLSAuthFeature",
            dependencies: [
                "MLSAuthFeatureInterface",
                .product(name: "MLSCore", package: "MLSCore"),
                .product(name: "MLSDesignSystem", package: "MLSDesignSystem"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxKeyboard", package: "RxKeyboard"),
                .product(name: "KakaoSDKAuth", package: "kakao-ios-sdk"),
                .product(name: "KakaoSDKUser", package: "kakao-ios-sdk"),
                .product(name: "SnapKit", package: "SnapKit"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Testing 모듈 (Mock 객체)
        .target(
            name: "MLSAuthFeatureTesting",
            dependencies: [
                "MLSAuthFeatureInterface",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // Tests 모듈
        .testTarget(
            name: "MLSAuthFeatureTests",
            dependencies: [
                "MLSAuthFeature",
                "MLSAuthFeatureInterface",
                "MLSAuthFeatureTesting",
            ]
        ),
    ]
)
