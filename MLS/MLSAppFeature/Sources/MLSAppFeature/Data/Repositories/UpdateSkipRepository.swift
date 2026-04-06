import Foundation

import MLSAppFeatureInterface

/// 업데이트 스킵 정보를 관리하는 Repository 구현체
public final class UpdateSkipRepository: UpdateSkipRepositoryProtocol, @unchecked Sendable {
    nonisolated(unsafe) private let localDataSource: UserDefaultsDataSource
    private let skipDuration: TimeInterval

    /// UpdateSkipRepository 초기화
    /// - Parameter skipDuration: 스킵 유효 기간 (기본값: 7일)
    public init(skipDuration: TimeInterval = 7 * 24 * 60 * 60) {
        self.localDataSource = UserDefaultsDataSource()
        self.skipDuration = skipDuration
    }

    /// 테스트용 초기화자
    /// - Parameters:
    ///   - localDataSource: 로컬 데이터 소스
    ///   - skipDuration: 스킵 유효 기간
    init(localDataSource: UserDefaultsDataSource, skipDuration: TimeInterval = 7 * 24 * 60 * 60) {
        self.localDataSource = localDataSource
        self.skipDuration = skipDuration
    }

    public func saveSkipVersion(_ version: Version, skippedAt date: Date) {
        localDataSource.saveSkipVersion(version, skippedAt: date)
    }

    public func isSkipValid(for version: Version) -> Bool {
        guard let skippedVersion = localDataSource.getSkippedVersion(),
              let skippedDate = localDataSource.getSkippedDate(),
              skippedVersion == version else {
            return false
        }

        // 스킵 기간이 지났는지 확인
        let elapsed = Date().timeIntervalSince(skippedDate)
        return elapsed >= 0 && elapsed < skipDuration
    }

    public func clearSkipInfo() {
        localDataSource.clearSkipInfo()
    }
}
