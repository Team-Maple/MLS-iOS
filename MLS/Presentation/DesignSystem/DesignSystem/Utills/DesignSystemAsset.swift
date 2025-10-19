import UIKit

public enum DesignSystemAsset {
    static let bundle: Bundle = {
        // 모듈의 번들을 특정 클래스 기반으로 가져옴
        return Bundle(for: DesignSystemMarker.self)
    }()

    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

/// Marker 클래스 - 번들 식별용
private class DesignSystemMarker {}

public enum MapleIllustration {
    case mushroom
    case slime
    case blueSnail
    case juniorYeti
    case yeti
    case pepe
    case wraith
    case starPixie
    case rash

    public var url: String {
        switch self {
        case .mushroom:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_1.jpg"
        case .slime:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_2.jpg"
        case .blueSnail:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_3.jpg"
        case .juniorYeti:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_4.jpg"
        case .yeti:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_5.jpg"
        case .pepe:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_6.jpg"
        case .wraith:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_7.jpg"
        case .starPixie:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_8.jpg"
        case .rash:
            "https://maple-db-team-s3.s3.ap-northeast-2.amazonaws.com/profile-images/profile_9.jpg"
        }
    }
}
