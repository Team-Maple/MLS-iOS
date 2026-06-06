import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

@Suite("DictionaryListReactorTests")
struct DictionaryListReactorTests {
    // MARK: - Mutate

    @Test("viewWillAppear 시 리스트 mutation 발생")
    func viewWillAppear_emitListMutation() throws {
        let reactor = makeSUT(type: .monster)

        let mutations = try reactor
            .mutate(action: .viewWillAppear)
            .toBlocking()
            .toArray()

        let hasListMutation = mutations.contains {
            if case .setListItem = $0 {
                return true
            }
            return false
        }

        #expect(hasListMutation)
    }

    @Test("정렬 선택 시 sort mutation 발생")
    func sortOptionSelected_emitSortMutation() throws {
        let reactor = makeSUT(type: .monster)

        let mutations = try reactor
            .mutate(action: .sortOptionSelected(.expASC))
            .toBlocking()
            .toArray()

        let hasSortMutation = mutations.contains {
            if case .setSort(let value) = $0 {
                return value == "exp,asc"
            }
            return false
        }

        #expect(hasSortMutation)
    }

    @Test("필터 선택 시 filter mutation 발생")
    func filterOptionSelected_emitFilterMutation() throws {
        let reactor = makeSUT(type: .monster)

        let mutations = try reactor
            .mutate(
                action: .filterOptionSelected(
                    startLevel: 10,
                    endLevel: 30
                )
            )
            .toBlocking()
            .toArray()

        let hasFilterMutation = mutations.contains {
            if case .setFilter(let start, let end) = $0 {
                return start == 10 && end == 30
            }
            return false
        }

        #expect(hasFilterMutation)
    }

    @Test("로그인 액션 시 login 이벤트 발생")
    func showLogin_emitLoginEvent() throws {
        let reactor = makeSUT(type: .monster)

        let mutation = try reactor
            .mutate(action: .showLogin)
            .toBlocking()
            .first()

        switch mutation {
        case .setEvent(let event):
            switch event {
            case .login:
                #expect(true)
            default:
                Issue.record("Expected login event")
            }

        default:
            Issue.record("Expected setEvent mutation")
        }
    }

    // MARK: - Reduce

    @Test("setCurrentPage mutation 시 페이지 증가")
    func reduce_setCurrentPage() {
        let reactor = makeSUT(type: .monster)

        let newState = reactor.reduce(
            state: reactor.initialState,
            mutation: .setCurrentPage
        )

        #expect(newState.currentPage == 1)
    }

    @Test("updateBookmarkId mutation 시 bookmarkId 변경")
    func reduce_updateBookmarkId() {
        let reactor = makeSUT(type: .monster)

        var state = reactor.initialState

        state.listItems = [
            DictionaryMainItemResponse(
                id: 1,
                name: "슬라임",
                imageUrl: "",
                level: 1,
                type: .monster,
                bookmarkId: nil
            )
        ]

        let newState = reactor.reduce(
            state: state,
            mutation: .updateBookmarkId(
                id: 1,
                newBookmarkId: 999
            )
        )

        #expect(newState.listItems.first?.bookmarkId == 999)
    }
}

// MARK: - Helpers

private extension DictionaryListReactorTests {
    func makeSUT(
        type: DictionaryType,
        keyword: String? = nil
    ) -> DictionaryListReactor {
        DictionaryListReactor(
            type: type,
            keyword: keyword,
            dictionaryListAPIRepository:
            MockDictionaryListAPIRepository(),

            checkLoginUseCase:
            CheckLoginUseCaseImpl(
                authRepository: MockAuthAPIRepository(),
                tokenRepository: MockTokenRepository()
            ),

            setBookmarkUseCase:
            SetBookmarkUseCaseImpl(
                repository: MockBookmarkRepository()
            ),

            parseItemFilterResultUseCase:
            ParseItemFilterResultUseCaseImpl()
        )
    }
}
