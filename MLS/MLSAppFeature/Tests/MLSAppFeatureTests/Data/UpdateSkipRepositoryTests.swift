import Foundation
import Testing

@testable import MLSAppFeature
@testable import MLSAppFeatureInterface

/// UpdateSkipRepository의 스킵 정보 저장, 조회, 유효성 검증 기능을 테스트합니다
@Suite("UpdateSkipRepository 테스트")
struct UpdateSkipRepositoryTests {

    /// 테스트용 UserDefaults와 Repository를 생성합니다
    func createRepository(suiteName: String = "com.mls.test.skip") -> (UpdateSkipRepository, UserDefaults) {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        userDefaults.synchronize()

        let dataSource = UserDefaultsDataSource(userDefaults: userDefaults)
        let repository = UpdateSkipRepository(localDataSource: dataSource)

        return (repository, userDefaults)
    }

    // MARK: - 저장 및 조회 테스트

    /// 스킵 정보를 저장하고 유효성 검증이 올바른지 확인합니다
    @Test("스킵 정보 저장 및 유효성 검증")
    func saveAndValidateSkip() {
        // Given
        let suiteName = "com.mls.test.skip.save"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let version = Version(major: 1, minor: 2, patch: 0)

        // When: 버전 스킵 저장
        repository.saveSkipVersion(version, skippedAt: Date())

        // Then: 스킵 정보가 유효함
        #expect(repository.isSkipValid(for: version))
    }

    // MARK: - 7일 정책 테스트

    /// 스킵한 지 3일 이내인 경우 유효한지 확인합니다
    @Test("스킵 유효: 7일 이내 (3일 전)")
    func skipValidWithinDuration() {
        // Given: 3일 전에 스킵함
        let suiteName = "com.mls.test.skip.valid"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let version = Version(major: 1, minor: 2, patch: 0)
        let threeDaysAgo = Date().addingTimeInterval(-3 * 24 * 60 * 60)

        // When
        repository.saveSkipVersion(version, skippedAt: threeDaysAgo)

        // Then: 7일 이내이므로 유효
        #expect(repository.isSkipValid(for: version))
    }

    /// 스킵한 지 8일이 지난 경우 무효한지 확인합니다
    @Test("스킵 무효: 7일 초과 (8일 전)")
    func skipInvalidAfterDuration() {
        // Given: 8일 전에 스킵함
        let suiteName = "com.mls.test.skip.expired"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let version = Version(major: 1, minor: 2, patch: 0)
        let eightDaysAgo = Date().addingTimeInterval(-8 * 24 * 60 * 60)

        // When
        repository.saveSkipVersion(version, skippedAt: eightDaysAgo)

        // Then: 7일을 초과했으므로 무효
        #expect(!repository.isSkipValid(for: version))
    }

    // MARK: - 버전 불일치 테스트

    /// 스킵한 버전과 다른 버전을 체크하면 무효한지 확인합니다
    @Test("스킵 무효: 버전 불일치")
    func skipInvalidForDifferentVersion() {
        // Given: v1.2.0을 스킵함
        let suiteName = "com.mls.test.skip.diff"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let v1 = Version(major: 1, minor: 2, patch: 0)
        let v2 = Version(major: 1, minor: 3, patch: 0)
        repository.saveSkipVersion(v1, skippedAt: Date())

        // When/Then: v1.3.0은 스킵되지 않았으므로 무효
        #expect(!repository.isSkipValid(for: v2))
    }

    // MARK: - 스킵 정보 삭제 테스트

    /// clearSkipInfo 호출 시 스킵 정보가 삭제되는지 확인합니다
    @Test("스킵 정보 삭제")
    func clearSkipInfo() {
        // Given: 스킵 정보 저장
        let suiteName = "com.mls.test.skip.clear"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let version = Version(major: 1, minor: 2, patch: 0)
        repository.saveSkipVersion(version, skippedAt: Date())

        // When: 스킵 정보 삭제
        repository.clearSkipInfo()

        // Then: 스킵 정보가 무효화됨
        #expect(!repository.isSkipValid(for: version))
    }

    // MARK: - 영속성 테스트

    /// UserDefaults에 저장된 데이터가 다른 Repository 인스턴스에서도 조회되는지 확인합니다
    @Test("UserDefaults 영속성")
    func persistence() {
        // Given: Repository1에서 스킵 정보 저장
        let suiteName = "com.mls.test.skip.persistence"
        let (repository, userDefaults) = createRepository(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let version = Version(major: 2, minor: 5, patch: 1)
        repository.saveSkipVersion(version, skippedAt: Date())

        // When: 새로운 Repository2 생성 (같은 UserDefaults 사용)
        let dataSource2 = UserDefaultsDataSource(userDefaults: userDefaults)
        let repository2 = UpdateSkipRepository(localDataSource: dataSource2)

        // Then: Repository2에서도 스킵 정보 조회 가능
        #expect(repository2.isSkipValid(for: version))
    }

    // MARK: - 커스텀 기간 테스트

    /// 스킵 기간을 커스터마이징할 수 있는지 확인합니다
    @Test("커스텀 스킵 기간: 1일")
    func customDuration() {
        // Given: 스킵 기간을 1일로 설정
        let suiteName = "com.mls.test.skip.custom"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        userDefaults.synchronize()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = UserDefaultsDataSource(userDefaults: userDefaults)
        let customRepo = UpdateSkipRepository(localDataSource: dataSource, skipDuration: 1 * 24 * 60 * 60)

        let version = Version(major: 1, minor: 2, patch: 0)
        let twoDaysAgo = Date().addingTimeInterval(-2 * 24 * 60 * 60)

        // When: 2일 전에 스킵함
        customRepo.saveSkipVersion(version, skippedAt: twoDaysAgo)

        // Then: 1일 기준으로는 무효
        #expect(!customRepo.isSkipValid(for: version))
    }
}
