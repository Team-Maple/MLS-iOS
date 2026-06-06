import RxBlocking
import Testing

@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

@Suite("DictionarySearchReactorTests")
struct DictionarySearchReactorTests {
    // MARK: - ViewWillAppear

    @Test("최근 검색어 조회")
    func test_viewWillAppear_fetchRecentSearches() throws {
        let reactor = makeSUT()

        let mutations = try reactor
            .mutate(action: .viewWillAppear)
            .toBlocking()
            .toArray()

        let hasRecentListMutation = mutations.contains {
            if case .setRecentList(let list) = $0 {
                return list.isEmpty == false
            }
            return false
        }

        #expect(hasRecentListMutation)
    }

    // MARK: - Search

    @Test("검색 실행 시 최근 검색어 추가 및 화면 이동")
    func test_searchButtonTapped_addRecentAndNavigate() throws {
        let reactor = makeSUT()

        let mutations = try reactor
            .mutate(action: .searchButtonTapped("슬라임"))
            .toBlocking()
            .toArray()

        let hasAddRecentMutation = mutations.contains {
            if case .addRecentItem(let keyword) = $0 {
                return keyword == "슬라임"
            }
            return false
        }

        let hasNavigateMutation = mutations.contains {
            if case .navigateTo(let route) = $0 {
                switch route {
                case .search(let keyword):
                    return keyword == "슬라임"
                default:
                    return false
                }
            }
            return false
        }

        #expect(hasAddRecentMutation)
        #expect(hasNavigateMutation)
    }

    @Test("최근 검색어 클릭 시 검색 화면 이동")
    func test_recentButtonTapped_navigateSearch() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .recentButtonTapped("주황버섯"))
            .toBlocking()
            .first()

        guard case .navigateTo(let route)? = mutation else {
            Issue.record("Expected navigateTo mutation")
            return
        }

        switch route {
        case .search(let keyword):
            #expect(keyword == "주황버섯")

        default:
            Issue.record("Expected search route")
        }
    }

    // MARK: - Delete Recent

    @Test("최근 검색어 삭제")
    func test_cancelRecentButtonTapped_deleteRecent() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .cancelRecentButtonTapped("슬라임"))
            .toBlocking()
            .first()

        guard case .deleteItem(let keyword)? = mutation else {
            Issue.record("Expected deleteItem mutation")
            return
        }

        #expect(keyword == "슬라임")
    }

    @Test("전체 최근 검색어 삭제")
    func test_deleteAllButtonTapped_deleteAll() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .deleteAllButtonTapped)
            .toBlocking()
            .first()

        guard case .deleteAllItems? = mutation else {
            Issue.record("Expected deleteAllItems mutation")
            return
        }

        #expect(true)
    }

    // MARK: - Navigation

    @Test("뒤로가기 클릭 시 dismiss 이동")
    func test_backButtonTapped_dismiss() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .backButtonTapped)
            .toBlocking()
            .first()

        guard case .navigateTo(let route)? = mutation else {
            Issue.record("Expected navigateTo mutation")
            return
        }

        switch route {
        case .dismiss:
            #expect(true)

        default:
            Issue.record("Expected dismiss route")
        }
    }

    // MARK: - Reduce

    @Test("reduce - 최근 검색어 추가")
    func test_reduce_addRecentItem() {
        let reactor = makeSUT()

        let newState = reactor.reduce(
            state: reactor.initialState,
            mutation: .addRecentItem("슬라임")
        )

        #expect(newState.recentResult.first == "슬라임")
    }

    @Test("reduce - 최근 검색어 삭제")
    func test_reduce_deleteItem() {
        let reactor = makeSUT()

        var state = reactor.initialState
        state.recentResult = ["슬라임", "주황버섯"]

        let newState = reactor.reduce(
            state: state,
            mutation: .deleteItem("슬라임")
        )

        #expect(newState.recentResult.contains("슬라임") == false)
        #expect(newState.recentResult.count == 1)
    }

    @Test("reduce - 최근 검색어 전체 삭제")
    func test_reduce_deleteAllItems() {
        let reactor = makeSUT()

        var state = reactor.initialState
        state.recentResult = ["슬라임", "주황버섯"]

        let newState = reactor.reduce(
            state: state,
            mutation: .deleteAllItems
        )

        #expect(newState.recentResult.isEmpty)
    }

    @Test("reduce - route 상태 변경")
    func test_reduce_navigateTo() {
        let reactor = makeSUT()

        let newState = reactor.reduce(
            state: reactor.initialState,
            mutation: .navigateTo(.search("슬라임"))
        )

        switch newState.route {
        case .search(let keyword):
            #expect(keyword == "슬라임")

        default:
            Issue.record("Expected search route")
        }
    }
}

// MARK: - Helpers

private extension DictionarySearchReactorTests {
    func makeSUT() -> DictionarySearchReactor {
        DictionarySearchReactor(
            recentSearchRepository:
            MockRecentSearchRepository()
        )
    }
}
