import RxBlocking
import Testing

@testable import MLSAuthFeatureTesting
@testable import MLSDictionaryFeature
@testable import MLSDictionaryFeatureInterface
@testable import MLSDictionaryFeatureTesting

// MARK: - MonsterDetail

@Suite("MonsterDictionaryDetailReactorTests")
struct MonsterDictionaryDetailReactorTests {
    // MARK: - Fetch

    @Test("상세 진입 시 상세 데이터 조회")
    func test_fetchMonsterDetail() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.monsterDetailInfo.monsterId == 1)
    }

    @Test("드롭 아이템 조회 성공")
    func test_fetchDropItems() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.dropItems.isEmpty == false)
    }

    @Test("맵 정보 조회 성공")
    func test_fetchMaps() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.spawnMaps.isEmpty == false)
    }

    @Test("로그인 상태 조회")
    func test_loginState() throws {
        let reactor = makeSUT()

        let state = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        #expect(state.isLogin == false)
    }

    // MARK: - Bookmark

    @Test("북마크 추가 성공")
    func test_toggleBookmark_addBookmark() throws {
        let reactor = makeSUT()

        let loadedState = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        let bookmarkState = try reduce(
            reactor,
            from: loadedState,
            action: .toggleBookmark
        )

        switch bookmarkState.event {
        case .add:
            #expect(true)

        default:
            Issue.record("Expected add event")
        }
    }

    @Test("북마크 undo 성공")
    func test_undoBookmark() throws {
        let reactor = makeSUT()

        let loadedState = try reduce(
            reactor,
            from: reactor.initialState,
            action: .viewWillAppear
        )

        _ = try reduce(
            reactor,
            from: loadedState,
            action: .toggleBookmark
        )

        let undoState = try reduce(
            reactor,
            from: loadedState,
            action: .undoLastDeletedBookmark
        )

        switch undoState.event {
        case .add:
            #expect(true)

        default:
            Issue.record("Expected add event")
        }
    }

    @Test("북마크 실패 시 에러 route 이동")
    func test_toggleBookmark_failure() throws {
        let reactor = makeFailureSUT()

        let mutations = try reactor
            .mutate(action: .toggleBookmark)
            .toBlocking()
            .toArray()

        let hasErrorRoute = mutations.contains {
            if case .navigateTo(.bookmarkError) = $0 {
                return true
            }
            return false
        }

        #expect(hasErrorRoute)
    }

    // MARK: - Route

    @Test("드롭 아이템 클릭 시 상세 이동")
    func test_reduce_itemDetailRoute() {
        let reactor = makeSUT()

        let newState = reactor.reduce(
            state: reactor.initialState,
            mutation: .navigateTo(
                .detail(type: .item, id: 1)
            )
        )

        switch newState.route {
        case let .detail(type, id):
            #expect(type == .item)
            #expect(id == 1)

        default:
            Issue.record("Expected item detail route")
        }
    }

    @Test("맵 클릭 시 상세 이동")
    func test_reduce_mapDetailRoute() {
        let reactor = makeSUT()

        let newState = reactor.reduce(
            state: reactor.initialState,
            mutation: .navigateTo(
                .detail(type: .map, id: 1)
            )
        )

        switch newState.route {
        case let .detail(type, id):
            #expect(type == .map)
            #expect(id == 1)

        default:
            Issue.record("Expected map detail route")
        }
    }

    @Test("필터 버튼 클릭 시 필터 화면 이동")
    func test_filterButtonTapped_navigateFilter() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .filterButtonTapped(.item))
            .toBlocking()
            .first()

        guard case let .navigateTo(route)? = mutation else {
            Issue.record("Expected navigate route")
            return
        }

        switch route {
        case let .filter(type, _):
            #expect(type == .item)

        default:
            Issue.record("Expected filter route")
        }
    }
}

// MARK: - Reduce Helpers

private func reduce(
    _ reactor: MonsterDictionaryDetailReactor,
    from state: MonsterDictionaryDetailReactor.State,
    action: MonsterDictionaryDetailReactor.Action
) throws -> MonsterDictionaryDetailReactor.State {
    let mutations = try reactor
        .mutate(action: action)
        .toBlocking()
        .toArray()

    return mutations.reduce(state) {
        reactor.reduce(state: $0, mutation: $1)
    }
}

// MARK: - SUT

private func makeSUT() -> MonsterDictionaryDetailReactor {
    MonsterDictionaryDetailReactor(
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

private func makeFailureSUT() -> MonsterDictionaryDetailReactor {
    MonsterDictionaryDetailReactor(
        dictionaryDetailAPIRepository:
        MockDictionaryDetailAPIRepository(),

        checkLoginUseCase:
        CheckLoginUseCaseImpl(
            authRepository: MockAuthAPIRepository(),
            tokenRepository: MockTokenRepository()
        ),

        setBookmarkUseCase:
        SetBookmarkUseCaseImpl(
            repository: MockBookmarkFailRepository()
        ),

        id: 1
    )
}
