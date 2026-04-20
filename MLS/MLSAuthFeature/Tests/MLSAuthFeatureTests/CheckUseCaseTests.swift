import Testing

@testable import MLSAuthFeature

@Suite("CheckValidLevelUseCase")
struct CheckValidLevelUseCaseTests {
    private let sut = CheckValidLevelUseCaseImpl()

    @Test("유효 레벨(1·100·200): true 반환", arguments: [1, 100, 200])
    func validLevel_returnsTrue(level: Int) {
        #expect(sut.execute(level: level) == true)
    }

    @Test("범위 외 레벨(0·201·-1): false 반환", arguments: [0, 201, -1])
    func outOfRangeLevel_returnsFalse(level: Int) {
        #expect(sut.execute(level: level) == false)
    }

    @Test("nil 레벨: nil 반환")
    func nilLevel_returnsNil() {
        #expect(sut.execute(level: nil) == nil)
    }
}

@Suite("CheckEmptyLevelAndRoleUseCase")
struct CheckEmptyLevelAndRoleUseCaseTests {
    private let sut = CheckEmptyLevelAndRoleUseCaseImpl()

    @Test("레벨·직업 모두 유효: true 반환")
    func bothValid_returnsTrue() {
        #expect(sut.execute(level: 50, job: "전사") == true)
    }

    @Test("레벨 nil: false 반환")
    func nilLevel_returnsFalse() {
        #expect(sut.execute(level: nil, job: "전사") == false)
    }

    @Test("레벨 범위 초과(0): false 반환")
    func outOfRangeLevel_returnsFalse() {
        #expect(sut.execute(level: 0, job: "전사") == false)
    }

    @Test("직업 nil: false 반환")
    func nilJob_returnsFalse() {
        #expect(sut.execute(level: 50, job: nil) == false)
    }

    @Test("직업 빈 문자열: false 반환")
    func emptyJob_returnsFalse() {
        #expect(sut.execute(level: 50, job: "") == false)
    }
}
