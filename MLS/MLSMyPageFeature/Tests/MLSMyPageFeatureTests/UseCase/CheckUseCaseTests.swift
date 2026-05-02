@testable import MLSMyPageFeature

import Testing

import RxBlocking

@Suite("CheckNickNameUseCase")
struct CheckNickNameUseCaseTests {
    private let sut = CheckNickNameUseCaseImpl()

    @Test("nickName이 빈 문자열이면 false")
    func emptyName_returnsFalse() throws {
        let result = try sut.execute(nickName: "").toBlocking().first()
        #expect(result == false)
    }

    @Test("nickName이 1글자면 false")
    func outOfRangeName_returnsFalse() throws {
        let result = try sut.execute(nickName: "메").toBlocking().first()
        #expect(result == false)
    }

    @Test("nickName이 2~8글자면 true")
    func validLengthName_returnsTrue() throws {
        let result = try sut.execute(nickName: "메이플").toBlocking().first()
        #expect(result == true)
    }
    
    @Test("nickName에 특수문자가 포함이면 false")
    func validName_returnsFalse() throws {
        let result = try sut.execute(nickName: "*메이플").toBlocking().first()
        #expect(result == false)
    }
    
    @Test("nickName에 공백이 포함이면 false")
    func blankName_returnsFalse() throws {
        let result = try sut.execute(nickName: "메이 플").toBlocking().first()
        #expect(result == false)
    }
}


@Suite("CheckValidLevelUseCaseTests")
struct CheckValidLevelUseCaseTests {
    private let sut = CheckValidLevelUseCaseImpl()

    @Test("level이 1이면 true")
    func minimumLevel_returnsTrue() {
        let result = sut.execute(level: 1)
        #expect(result == true)
    }
    
    @Test("level이 200이면 true")
    func maximumLevel_returnsTrue() {
        let result = sut.execute(level: 200)
        #expect(result == true)
    }

    @Test("level이 0이면 false")
    func outOfRangeLowerLevel_returnsFalse() {
        let result = sut.execute(level: 0)
        #expect(result == false)
    }
    
    @Test("level이 201이면 false")
    func outOfRangeUpperLevel_returnsFalse() {
        let result = sut.execute(level: 201)
        #expect(result == false)
    }
    
    @Test("level이 nil이면 nil")
    func nilLevel_returnsFalse() {
        let result = sut.execute(level: nil)
        #expect(result == nil)
    }
}
