import Foundation

import MLSAppFeatureInterface

/// 앱스토어 정보를 조회하는 Repository 구현체
public final class AppStoreRepository: AppStoreRepositoryProtocol, @unchecked Sendable {
    nonisolated(unsafe) private let remoteDataSource: AppStoreService

    public init() {
        self.remoteDataSource = AppStoreService()
    }

    /// 테스트용 초기화자
    init(remoteDataSource: AppStoreService) {
        self.remoteDataSource = remoteDataSource
    }

    public func fetchLatestVersion(appID: String) async throws -> Version {
        return try await remoteDataSource.fetchLatestVersion(appID: appID)
    }
}
