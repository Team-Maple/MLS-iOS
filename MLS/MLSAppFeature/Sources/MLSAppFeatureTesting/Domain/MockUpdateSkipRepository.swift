import Foundation
import MLSAppFeatureInterface

/// 테스트용 MockUpdateSkipRepository
public final class MockUpdateSkipRepository: UpdateSkipRepositoryProtocol, @unchecked Sendable {
    private var skippedVersion: Version?
    private var skippedDate: Date?
    public var skipDuration: TimeInterval = 7 * 24 * 60 * 60

    public var saveCallCount = 0
    public var clearCallCount = 0

    public init() {}

    public func saveSkipVersion(_ version: Version, skippedAt date: Date) {
        saveCallCount += 1
        skippedVersion = version
        skippedDate = date
    }

    public func isSkipValid(for version: Version) -> Bool {
        guard let skippedVersion = skippedVersion,
              let skippedDate = skippedDate else {
            return false
        }

        guard skippedVersion == version else {
            return false
        }

        let currentDate = Date()
        let elapsedTime = currentDate.timeIntervalSince(skippedDate)

        return elapsedTime < skipDuration
    }

    public func clearSkipInfo() {
        clearCallCount += 1
        skippedVersion = nil
        skippedDate = nil
    }

    /// Mock 데이터를 초기화합니다
    public func reset() {
        skippedVersion = nil
        skippedDate = nil
        saveCallCount = 0
        clearCallCount = 0
    }

    // MARK: - Test Helpers

    /// 테스트용 헬퍼 메서드
    public func getSkippedVersion() -> Version? {
        return skippedVersion
    }

    /// 테스트용 헬퍼 메서드
    public func getSkippedDate() -> Date? {
        return skippedDate
    }
}
