import Testing
import Foundation

@testable import MLSAppFeature
@testable import MLSAppFeatureInterface
@testable import MLSAppFeatureTesting

/// UpdateChecker Use Case의 업데이트 판단 로직과 스킵 기능을 테스트합니다
@Suite("UpdateChecker Use Case 테스트")
struct UpdateCheckerUseCaseTests {
    let mockAppStoreRepository: MockAppStoreRepository
    let mockSkipRepository: MockUpdateSkipRepository
    let useCase: UpdateCheckerUseCase

    /// 각 테스트마다 새로운 Mock 객체와 UseCase를 생성합니다
    init() {
        mockAppStoreRepository = MockAppStoreRepository()
        mockSkipRepository = MockUpdateSkipRepository()
        useCase = UpdateCheckerUseCase(
            appID: "123456789",
            appStoreRepository: mockAppStoreRepository,
            skipRepository: mockSkipRepository
        )
    }

    // MARK: - 강제 업데이트 테스트

    /// major 버전이 다를 때 강제 업데이트가 반환되는지 확인합니다
    @Test("강제 업데이트: major 버전 차이")
    func forceUpdate() async throws {
        // Given: 앱스토어 버전이 2.0.0, 현재 버전이 1.0.0
        mockAppStoreRepository.mockVersion = Version(major: 2, minor: 0, patch: 0)
        let currentVersion = Version(major: 1, minor: 0, patch: 0)

        // When: 업데이트 체크
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 강제 업데이트 상태
        guard case .force(let latest) = status else {
            Issue.record("Expected force update status")
            return
        }
        #expect(latest == Version(major: 2, minor: 0, patch: 0))
    }

    // MARK: - 선택 업데이트 테스트

    /// minor 버전이 다를 때 선택 업데이트가 반환되는지 확인합니다
    @Test("선택 업데이트: minor 버전 차이")
    func optionalUpdate() async throws {
        // Given: 앱스토어 버전이 1.2.0, 현재 버전이 1.1.0
        mockAppStoreRepository.mockVersion = Version(major: 1, minor: 2, patch: 0)
        let currentVersion = Version(major: 1, minor: 1, patch: 0)

        // When: 업데이트 체크
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 선택 업데이트 상태
        guard case .optional(let latest) = status else {
            Issue.record("Expected optional update status")
            return
        }
        #expect(latest == Version(major: 1, minor: 2, patch: 0))
    }

    // MARK: - 업데이트 불필요 테스트

    /// 현재 버전과 최신 버전이 같을 때 none이 반환되는지 확인합니다
    @Test("업데이트 불필요: 동일한 버전")
    func noneUpdate() async throws {
        // Given: 앱스토어 버전과 현재 버전이 모두 1.0.0
        mockAppStoreRepository.mockVersion = Version(major: 1, minor: 0, patch: 0)
        let currentVersion = Version(major: 1, minor: 0, patch: 0)

        // When: 업데이트 체크
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 업데이트 불필요
        #expect(status == .none)
    }

    // MARK: - 스킵 로직 테스트

    /// 사용자가 스킵한 버전이 7일 이내인 경우 none이 반환되는지 확인합니다
    @Test("스킵 로직: 유효한 스킵 (7일 이내)")
    func skipLogicValid() async throws {
        // Given: 최신 버전 1.2.0을 오늘 스킵함
        let latest = Version(major: 1, minor: 2, patch: 0)
        mockAppStoreRepository.mockVersion = latest
        mockSkipRepository.saveSkipVersion(latest, skippedAt: Date())

        // When: 업데이트 체크
        let currentVersion = Version(major: 1, minor: 1, patch: 0)
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 스킵이 유효하므로 none 반환
        #expect(status == .none)
    }

    /// 스킵한 지 7일이 지난 경우 다시 optional이 반환되는지 확인합니다
    @Test("스킵 로직: 만료된 스킵 (7일 초과)")
    func skipLogicExpired() async throws {
        // Given: 최신 버전 1.2.0을 8일 전에 스킵함
        let latest = Version(major: 1, minor: 2, patch: 0)
        mockAppStoreRepository.mockVersion = latest
        let eightDaysAgo = Date().addingTimeInterval(-8 * 24 * 60 * 60)
        mockSkipRepository.saveSkipVersion(latest, skippedAt: eightDaysAgo)

        // When: 업데이트 체크
        let currentVersion = Version(major: 1, minor: 1, patch: 0)
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 스킵이 만료되어 optional 반환
        guard case .optional = status else {
            Issue.record("Expected optional update status")
            return
        }
    }

    /// 강제 업데이트는 스킵 정보를 무시하고 항상 force를 반환하는지 확인합니다
    @Test("스킵 로직: 강제 업데이트는 스킵 무시")
    func forceUpdateIgnoresSkip() async throws {
        // Given: 최신 버전 2.0.0을 스킵했지만 major 버전 차이
        let latest = Version(major: 2, minor: 0, patch: 0)
        mockAppStoreRepository.mockVersion = latest
        mockSkipRepository.saveSkipVersion(latest, skippedAt: Date())

        // When: 업데이트 체크
        let currentVersion = Version(major: 1, minor: 0, patch: 0)
        let status = try await useCase.checkUpdate(currentVersion: currentVersion)

        // Then: 스킵을 무시하고 강제 업데이트 반환
        guard case .force = status else {
            Issue.record("Expected force update status")
            return
        }
    }

    // MARK: - 스킵 관리 테스트

    /// skipUpdate 호출 시 Repository에 저장이 요청되는지 확인합니다
    @Test("스킵 저장 기능")
    func skipUpdate() {
        // Given
        let version = Version(major: 1, minor: 2, patch: 0)

        // When: 버전 스킵
        useCase.skipUpdate(version: version)

        // Then: Repository의 save가 호출됨
        #expect(mockSkipRepository.saveCallCount == 1)
    }

    /// clearSkipInfo 호출 시 Repository의 clear가 호출되는지 확인합니다
    @Test("스킵 정보 초기화")
    func clearSkipInfo() {
        // When: 스킵 정보 초기화
        useCase.clearSkipInfo()

        // Then: Repository의 clear가 호출됨
        #expect(mockSkipRepository.clearCallCount == 1)
    }

    // MARK: - 에러 처리 테스트

    /// 앱스토어 조회 실패 시 에러가 전파되는지 확인합니다
    @Test("에러 처리: 앱스토어 조회 실패")
    func errorHandling() async throws {
        // Given: 앱스토어 조회 시 에러 발생
        mockAppStoreRepository.mockError = AppStoreError.invalidResponse

        // When/Then: 에러가 전파됨
        await #expect(throws: AppStoreError.self) {
            try await useCase.checkUpdate(currentVersion: Version(major: 1, minor: 0, patch: 0))
        }
    }
}
