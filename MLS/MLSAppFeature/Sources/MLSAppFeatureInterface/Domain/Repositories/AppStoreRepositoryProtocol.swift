import Foundation

/// 앱스토어 정보를 조회하는 Repository 프로토콜
public protocol AppStoreRepositoryProtocol: Sendable {
    /// 앱스토어에서 최신 버전을 조회합니다
    /// - Parameter appID: 앱스토어 앱 ID
    /// - Returns: 최신 버전 정보
    /// - Throws: 조회 실패 시 AppStoreError
    func fetchLatestVersion(appID: String) async throws -> Version
}

/// 앱스토어 조회 시 발생할 수 있는 에러
public enum AppStoreError: Error, Equatable, Sendable {
    case invalidURL
    case networkFailure
    case invalidResponse
    case versionNotFound
    case parsingError
}
