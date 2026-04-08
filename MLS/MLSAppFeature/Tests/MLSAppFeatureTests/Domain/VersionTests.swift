import Testing

@testable import MLSAppFeatureInterface

/// Version 엔티티의 생성, 비교, 파싱 기능을 테스트합니다
@Suite("Version 엔티티 테스트")
struct VersionTests {

    // MARK: - 초기화 테스트

    /// 버전을 major, minor, patch로 초기화하고 속성이 올바른지 확인합니다
    @Test("버전 초기화 및 문자열 변환")
    func versionInitialization() {
        let version = Version(major: 1, minor: 2, patch: 3)

        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
        #expect(version.versionString == "1.2.3")
    }

    /// 버전 문자열로부터 Version 객체를 생성하고 파싱이 올바른지 확인합니다
    @Test("버전 문자열 파싱")
    func versionFromString() {
        // 정상 케이스: "1.2.3"
        #expect(Version(versionString: "1.2.3") == Version(major: 1, minor: 2, patch: 3))

        // patch가 없는 경우: "1.2" → patch는 0으로 처리
        #expect(Version(versionString: "1.2") == Version(major: 1, minor: 2, patch: 0))

        // 잘못된 형식
        #expect(Version(versionString: "invalid") == nil)
        #expect(Version(versionString: "1") == nil)
    }

    // MARK: - 비교 테스트

    /// 버전 간 비교 연산자가 올바르게 동작하는지 확인합니다
    @Test("버전 비교 연산")
    func versionComparison() {
        let v1 = Version(major: 1, minor: 0, patch: 0)
        let v2 = Version(major: 2, minor: 0, patch: 0)
        let v3 = Version(major: 1, minor: 2, patch: 0)
        let v4 = Version(major: 1, minor: 2, patch: 3)

        // major 버전 비교
        #expect(v1 < v2)

        // minor 버전 비교
        #expect(v1 < v3)

        // patch 버전 비교
        #expect(v3 < v4)

        // 동등 비교
        #expect(v1 == Version(major: 1, minor: 0, patch: 0))
    }
}
