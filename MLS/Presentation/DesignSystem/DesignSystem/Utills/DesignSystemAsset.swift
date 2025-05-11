import UIKit

enum DesignSystemAsset {
    static let bundle: Bundle = {
        // 모듈의 번들을 특정 클래스 기반으로 가져옴
        return Bundle(for: DesignSystemMarker.self)
    }()

    static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
}

/// Marker 클래스 - 번들 식별용
private class DesignSystemMarker {}
