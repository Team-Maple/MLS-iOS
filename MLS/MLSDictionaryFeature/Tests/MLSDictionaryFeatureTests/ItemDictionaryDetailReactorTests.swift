import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

// MARK: - ItemDetail

@Suite("ItemDictionaryDetailReactorTests")
struct ItemDictionaryDetailReactorTests {
    @Test("상세 진입 시 상세 데이터 조회")
    func test_fetchItemDetail() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.itemDetailInfo.itemId == 1)
    }

    @Test("드롭 몬스터 조회 성공")
    func test_fetchDropMonsters() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.monsters.isEmpty == false)
    }
}

// MARK: - Reduce Helpers

private func reduce(
    _ reactor: ItemDictionaryDetailReactor,
    from state: ItemDictionaryDetailReactor.State,
    action: ItemDictionaryDetailReactor.Action
) throws -> ItemDictionaryDetailReactor.State {
    let mutations = try reactor
        .mutate(action: action)
        .toBlocking()
        .toArray()

    return mutations.reduce(state) {
        reactor.reduce(state: $0, mutation: $1)
    }
}

// MARK: - SUT

private func makeSUT() -> ItemDictionaryDetailReactor {
    ItemDictionaryDetailReactor(
        dictionaryDetailAPIRepository:
        MockDictionaryDetailAPIRepository(),

        checkLoginUseCase:
        CheckLoginUseCaseImpl(
            authRepository: MockAuthAPIRepository(),
            tokenRepository: MockTokenRepository()
        ),

        setBookmarkUseCase:
        SetBookmarkUseCaseImpl(
            repository: MockBookmarkRepository()
        ),

        id: 1
    )
}
