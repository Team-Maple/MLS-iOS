import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

@Suite("MapDictionaryDetailReactorTests")
struct MapDictionaryDetailReactorTests {
    @Test("상세 진입 시 상세 데이터 조회")
    func test_fetchMapDetail() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.mapDetailInfo.mapId == 1)
    }

    @Test("스폰 몬스터 조회 성공")
    func test_fetchSpawnMonsters() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.spawnMonsters.isEmpty == false)
    }

    @Test("NPC 조회 성공")
    func test_fetchNpc() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.npcs.isEmpty == false)
    }
}

// MARK: - Reduce Helpers
private func reduce(
    _ reactor: MapDictionaryDetailReactor,
    from state: MapDictionaryDetailReactor.State,
    action: MapDictionaryDetailReactor.Action
) throws -> MapDictionaryDetailReactor.State {
    let mutations = try reactor
        .mutate(action: action)
        .toBlocking()
        .toArray()

    return mutations.reduce(state) {
        reactor.reduce(state: $0, mutation: $1)
    }
}

// MARK: - SUT

private func makeSUT() -> MapDictionaryDetailReactor {
    MapDictionaryDetailReactor(
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
