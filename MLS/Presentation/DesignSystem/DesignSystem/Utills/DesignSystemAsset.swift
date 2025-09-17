import UIKit

public enum DesignSystemAsset {
    static let bundle: Bundle = {
        // 모듈의 번들을 특정 클래스 기반으로 가져옴
        return Bundle(for: DesignSystemMarker.self)
    }()

    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    public static func loadMapleIllustration(type: MapleIllustration, isSelected: Bool = false) -> UIImage? {
        return UIImage(named: isSelected ? "\(type.rawValue)Selected" : type.rawValue, in: bundle, compatibleWith: nil)
    }
}

/// Marker 클래스 - 번들 식별용
private class DesignSystemMarker {}

public enum MapleIllustration: String {
    case mushroom
    case slime
    case blueSnail
    case juniorYeti
    case yeti
    case pepe
    case wraith
    case starPixie
    case rash
}
