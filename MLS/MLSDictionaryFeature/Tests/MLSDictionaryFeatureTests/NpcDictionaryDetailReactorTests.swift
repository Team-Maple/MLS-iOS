import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

// MARK: - NpcDetail

@Suite("NpcDictionaryDetailReactorTests")
struct NpcDictionaryDetailReactorTests {
    @Test("상세 진입 시 상세 데이터 조회")
    func test_fetchNpcDetail() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.npcDetailInfo.npcId == 1)
    }

    @Test("상세 맵 조회 성공")
    func test_fetchMaps() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.maps.isEmpty == false)
    }

    @Test("퀘스트 조회 성공")
    func test_fetchQuests() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.quests.isEmpty == false)
    }
}

// MARK: - Reduce Helpers
private func reduce(
    _ reactor: NpcDictionaryDetailReactor,
    from state: NpcDictionaryDetailReactor.State,
    action: NpcDictionaryDetailReactor.Action
) throws -> NpcDictionaryDetailReactor.State {
    let mutations = try reactor
        .mutate(action: action)
        .toBlocking()
        .toArray()

    return mutations.reduce(state) {
        reactor.reduce(state: $0, mutation: $1)
    }
}

// MARK: - SUT
private func makeSUT() -> NpcDictionaryDetailReactor {
    NpcDictionaryDetailReactor(
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
