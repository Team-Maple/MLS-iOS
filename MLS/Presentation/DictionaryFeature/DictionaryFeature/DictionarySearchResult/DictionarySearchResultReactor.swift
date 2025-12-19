import ReactorKit

import DomainInterface

public final class DictionarySearchResultReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
    }

    public enum Action {
        case backbuttonTapped
        case updateKeyword(String)
        case viewWillAppear
        case searchButtonTapped(String?)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setKeyword(String)
        case setCounts([Int])
    }

    public struct State {
        @Pulse var route: Route = .none
        let type = DictionaryMainViewType.search
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }

        var keyword: String?

        var counts: [Int] = [0, 0, 0, 0, 0, 0]
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - UseCases
    private let dictionarySearchUseCase: FetchDictionarySearchListUseCase
    private let dictionarySearchCountUseCase: FetchDictionaryListCountUseCase
    private let recentSearchAddUseCase: RecentSearchAddUseCase

    // MARK: - init
    public init(keyword: String?, dictionarySearchUseCase: FetchDictionarySearchListUseCase, dictionarySearchCountUseCase: FetchDictionaryListCountUseCase, recentSearchAddUseCase: RecentSearchAddUseCase) {
        self.initialState = State(keyword: keyword)
        self.dictionarySearchUseCase = dictionarySearchUseCase
        self.dictionarySearchCountUseCase = dictionarySearchCountUseCase
        self.recentSearchAddUseCase = recentSearchAddUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backbuttonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .updateKeyword(let keyword):
            return Observable.just(.setKeyword(keyword))
        case .viewWillAppear:
            // 초기 검색 시, state.keyword를 그대로 사용
            // transform에서 keyword 변화 감지 후 호출됨
            if let keyword = currentState.keyword {
                return Observable.just(.setKeyword(keyword))
            } else {
                return .empty()
            }
        // 검색 결과 화면에서 재검색 시
        case .searchButtonTapped(let keyword):
            let keyword = keyword ?? ""
            return recentSearchAddUseCase.add(keyword: keyword)
                .andThen(.just(.setKeyword(keyword)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setKeyword(let keyword):
            newState.keyword = keyword
        case .setCounts(let counts):
            newState.counts = counts
        }

        return newState
    }

    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let keywordChanges = mutation
            .compactMap { mutation -> String? in
                if case .setKeyword(let keyword) = mutation { return keyword }
                return nil
            }
            .distinctUntilChanged() // 중복 keyword 방지
            .flatMap { [weak self] keyword -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let types = ["search", "monsters", "items", "maps", "npcs", "quests"]
                let countObservables = types.map { type in
                    self.dictionarySearchCountUseCase.execute(type: type, keyword: keyword)
                        .map { $0.count ?? 0 }
                }
                return Observable.zip(countObservables)
                    .map { counts in
                        Mutation.setCounts(counts)
                    }
            }

        return Observable.merge(mutation, keywordChanges)
    }
}
