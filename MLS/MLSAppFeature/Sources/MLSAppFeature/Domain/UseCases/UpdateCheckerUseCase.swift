import Foundation

import MLSAppFeatureInterface

/// 앱 업데이트 체크 Use Case 구현체
public final class UpdateCheckerUseCase: UpdateCheckerUseCaseProtocol {
    private let appStoreRepository: AppStoreRepositoryProtocol
    private let skipRepository: UpdateSkipRepositoryProtocol
    private let appID: String

    /// UpdateCheckerUseCase 초기화
    /// - Parameters:
    ///   - appID: 앱스토어 앱 ID
    ///   - appStoreRepository: 앱스토어 정보 조회 Repository
    ///   - skipRepository: 스킵 정보 관리 Repository
    public init(
        appID: String,
        appStoreRepository: AppStoreRepositoryProtocol,
        skipRepository: UpdateSkipRepositoryProtocol
    ) {
        self.appID = appID
        self.appStoreRepository = appStoreRepository
        self.skipRepository = skipRepository
    }

    public func checkUpdate(currentVersion: Version) async throws -> UpdateStatus {
        let latestVersion = try await appStoreRepository.fetchLatestVersion(appID: appID)

        // 최신 버전이 현재 버전보다 낮거나 같으면 업데이트 불필요
        guard latestVersion > currentVersion else {
            return .none
        }

        // major 버전이 다르면 강제 업데이트
        if latestVersion.major != currentVersion.major {
            return .force(latestVersion: latestVersion)
        }

        // minor 또는 patch 차이면 선택 업데이트
        // 단, 사용자가 이전에 스킵했고 7일이 지나지 않았으면 none 반환
        if skipRepository.isSkipValid(for: latestVersion) {
            return .none
        }

        return .optional(latestVersion: latestVersion)
    }

    public func skipUpdate(version: Version) {
        skipRepository.saveSkipVersion(version, skippedAt: Date())
    }

    public func clearSkipInfo() {
        skipRepository.clearSkipInfo()
    }
}
