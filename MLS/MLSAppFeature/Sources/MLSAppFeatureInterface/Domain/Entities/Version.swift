import Foundation

/// 앱 버전을 나타내는 도메인 엔티티
/// major.minor.patch 형식의 시맨틱 버저닝을 지원합니다
public struct Version: Equatable, Comparable, Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// 버전 문자열로부터 Version 객체를 생성합니다
    /// - Parameter versionString: "1.2.3" 형식의 버전 문자열
    /// - Returns: 파싱에 성공하면 Version 객체, 실패하면 nil
    public init?(versionString: String) {
        let components = versionString.split(separator: ".").compactMap { Int($0) }
        guard components.count >= 2 else { return nil }

        self.major = components[0]
        self.minor = components[1]
        self.patch = components.count > 2 ? components[2] : 0
    }

    /// 버전을 문자열로 반환합니다
    public var versionString: String {
        "\(major).\(minor).\(patch)"
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
