import Foundation

/// 앱 업데이트 상태를 나타내는 열거형
public enum UpdateStatus: Equatable, Sendable {
    /// 강제 업데이트 필요 (major 버전 차이)
    case force(latestVersion: Version)

    /// 선택적 업데이트 가능 (minor 또는 patch 차이)
    case optional(latestVersion: Version)

    /// 업데이트 불필요
    case none
}
