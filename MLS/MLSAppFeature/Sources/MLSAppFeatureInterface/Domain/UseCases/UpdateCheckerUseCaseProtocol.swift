import Foundation

/// 앱 업데이트 체크를 담당하는 Use Case 프로토콜
public protocol UpdateCheckerUseCaseProtocol: Sendable {
    /// 현재 버전과 앱스토어의 최신 버전을 비교하여 업데이트 상태를 반환합니다
    /// - Parameter currentVersion: 현재 앱 버전
    /// - Returns: 업데이트 상태 (force, optional, none)
    /// - Throws: 앱스토어 조회 실패 시 에러
    func checkUpdate(currentVersion: Version) async throws -> UpdateStatus

    /// 사용자가 선택 업데이트를 스킵했을 때 호출합니다
    /// - Parameter version: 스킵할 버전
    func skipUpdate(version: Version)

    /// 스킵 정보를 초기화합니다
    func clearSkipInfo()
}
