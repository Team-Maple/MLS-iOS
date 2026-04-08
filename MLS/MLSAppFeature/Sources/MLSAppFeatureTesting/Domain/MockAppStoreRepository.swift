import Foundation
import MLSAppFeatureInterface

/// 테스트용 MockAppStoreRepository
public final class MockAppStoreRepository: AppStoreRepositoryProtocol, @unchecked Sendable {
    public var mockVersion: Version?
    public var mockError: Error?
    public var fetchCallCount = 0

    public init() {}

    public func fetchLatestVersion(appID: String) async throws -> Version {
        fetchCallCount += 1

        if let error = mockError {
            throw error
        }

        guard let version = mockVersion else {
            throw AppStoreError.versionNotFound
        }

        return version
    }

    /// Mock 데이터를 초기화합니다
    public func reset() {
        mockVersion = nil
        mockError = nil
        fetchCallCount = 0
    }
}
