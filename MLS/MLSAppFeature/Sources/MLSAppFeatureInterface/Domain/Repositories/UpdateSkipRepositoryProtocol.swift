import Foundation

/// 업데이트 스킵 정보를 관리하는 Repository 프로토콜
public protocol UpdateSkipRepositoryProtocol: Sendable {
    /// 특정 버전에 대한 스킵 정보를 저장합니다
    /// - Parameters:
    ///   - version: 스킵할 버전
    ///   - date: 스킵 날짜
    func saveSkipVersion(_ version: Version, skippedAt date: Date)

    /// 특정 버전에 대한 스킵 정보가 유효한지 확인합니다
    /// - Parameter version: 확인할 버전
    /// - Returns: 스킵 정보가 유효하면 true (7일 이내)
    func isSkipValid(for version: Version) -> Bool

    /// 저장된 스킵 정보를 삭제합니다
    func clearSkipInfo()
}
