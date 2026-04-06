import Foundation

import MLSAppFeatureInterface

/// UserDefaults를 사용하는 Local Data Source
final class UserDefaultsDataSource {
    nonisolated(unsafe) private let userDefaults: UserDefaults
    private let versionKey = "com.mls.updateChecker.skippedVersion"
    private let dateKey = "com.mls.updateChecker.skippedDate"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    /// 스킵 버전을 저장합니다
    func saveSkipVersion(_ version: Version, skippedAt date: Date) {
        userDefaults.set(version.versionString, forKey: versionKey)
        userDefaults.set(date.timeIntervalSince1970, forKey: dateKey)
        userDefaults.synchronize()
    }

    /// 저장된 스킵 버전을 조회합니다
    func getSkippedVersion() -> Version? {
        guard let versionString = userDefaults.string(forKey: versionKey) else {
            return nil
        }
        return Version(versionString: versionString)
    }

    /// 스킵 날짜를 조회합니다
    func getSkippedDate() -> Date? {
        let timestamp = userDefaults.double(forKey: dateKey)
        guard timestamp > 0 else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }

    /// 스킵 정보를 삭제합니다
    func clearSkipInfo() {
        userDefaults.removeObject(forKey: versionKey)
        userDefaults.removeObject(forKey: dateKey)
        userDefaults.synchronize()
    }
}
