import Testing

@testable import MLSDictionaryFeature

@Suite("ParseItemFilterResultUseCaseTests")
struct ParseItemFilterResultUseCaseTests {
    let sut = ParseItemFilterResultUseCaseImpl()

    // MARK: - Job

    @Test("직업 필터 파싱")
    func test_parseJobFilter() {
        let result = sut.execute(
            results: [
                ("직업", "전사"),
                ("직업", "궁수")
            ]
        )

        #expect(result.jobIds == [100, 300])
    }

    // MARK: - Level

    @Test("레벨 범위 파싱")
    func test_parseLevelRange() {
        let result = sut.execute(
            results: [
                ("레벨", "10레벨 ~ 30레벨")
            ]
        )

        #expect(result.startLevel == 10)
        #expect(result.endLevel == 30)
    }

    // MARK: - Category

    @Test("카테고리 파싱")
    func test_parseCategoryFilter() {
        let result = sut.execute(
            results: [
                ("무기", "한손검"),
                ("방어구", "모자")
            ]
        )

        #expect(result.categoryIds == [7, 24])
    }

    @Test("주문서 카테고리 파싱")
    func test_parseScrollCategoryFilter() {
        let result = sut.execute(
            results: [
                ("무기주문서", "한손검")
            ]
        )

        #expect(result.categoryIds == [50])
    }

    // MARK: - Empty

    @Test("빈 값 처리")
    func test_parseEmptyValues() {
        let result = sut.execute(results: [])

        #expect(result.jobIds.isEmpty)
        #expect(result.categoryIds.isEmpty)
        #expect(result.startLevel == nil)
        #expect(result.endLevel == nil)
    }

    // MARK: - Duplicate

    @Test("중복 값 허용")
    func test_duplicateValuesAllowed() {
        let result = sut.execute(
            results: [
                ("직업", "전사"),
                ("직업", "전사")
            ]
        )

        #expect(result.jobIds == [100, 100])
    }

    // MARK: - Invalid

    @Test("잘못된 값은 무시")
    func test_ignoreInvalidValues() {
        let result = sut.execute(
            results: [
                ("직업", "해직"),
                ("무기", "레이저건")
            ]
        )

        #expect(result.jobIds.isEmpty)
        #expect(result.categoryIds.isEmpty)
    }

    @Test("복합 필터 파싱")

    func test_parseComplexFilters() {
        let result = sut.execute(
            results: [
                ("직업", "전사"),
                ("레벨", "10레벨 ~ 30레벨"),
                ("무기", "한손검")
            ]
        )

        #expect(result.jobIds == [100])
        #expect(result.startLevel == 10)
        #expect(result.endLevel == 30)
        #expect(result.categoryIds == [7])
    }
}
