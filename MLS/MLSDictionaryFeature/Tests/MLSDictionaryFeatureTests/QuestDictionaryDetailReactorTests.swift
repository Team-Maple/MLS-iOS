import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

// MARK: - QuestDetail

@Suite("QuestDictionaryDetailReactorTests")
struct QuestDictionaryDetailReactorTests {
    @Test("상세 진입 시 상세 데이터 조회")
    func test_fetchQuestDetail() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.detailInfo.questId == 1)
    }

    @Test("연계 퀘스트 조회 성공")
    func test_fetchLinkedQuests() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(
            state.linkedQuestInfo.nextQuests != nil ||
                state.linkedQuestInfo.previousQuests != nil
        )
    }
}

// MARK: - Reduce Helpers

private func reduce(
    _ reactor: QuestDictionaryDetailReactor,
    from state: QuestDictionaryDetailReactor.State,
    action: QuestDictionaryDetailReactor.Action
) throws -> QuestDictionaryDetailReactor.State {
    let mutations = try reactor
        .mutate(action: action)
        .toBlocking()
        .toArray()

    return mutations.reduce(state) {
        reactor.reduce(state: $0, mutation: $1)
    }
}

// MARK: - SUT

private func makeSUT() -> QuestDictionaryDetailReactor {
    QuestDictionaryDetailReactor(
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
