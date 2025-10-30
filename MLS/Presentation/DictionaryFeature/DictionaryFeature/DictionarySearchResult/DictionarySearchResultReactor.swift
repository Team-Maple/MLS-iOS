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
        case setKeyword2(String)
        case setCountsAll(SearchCountResponse)
        case setCountsMonster(SearchCountResponse)
        case setCountsItem(SearchCountResponse)
        case setCountsNpc(SearchCountResponse)
        case setCountsQuest(SearchCountResponse)
        case setCountsMap(SearchCountResponse)
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

    // MARK: - init
    public init(keyword: String?, dictionarySearchUseCase: FetchDictionarySearchListUseCase, dictionarySearchCountUseCase: FetchDictionaryListCountUseCase) {
        self.initialState = State(keyword: keyword)
        self.dictionarySearchUseCase = dictionarySearchUseCase
        self.dictionarySearchCountUseCase = dictionarySearchCountUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backbuttonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .updateKeyword(let keyword):
            return Observable.just(.setKeyword(keyword))
        case .viewWillAppear:
            // 초기 검색 시
            return Observable.concat([
                // 초기 키워드
                self.dictionarySearchCountUseCase.execute(type: "search", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsAll($0)},
                self.dictionarySearchCountUseCase.execute(type: "monsters", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsMonster($0)},
                self.dictionarySearchCountUseCase.execute(type: "items", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsItem($0)},
                self.dictionarySearchCountUseCase.execute(type: "npcs", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsNpc($0)},
                self.dictionarySearchCountUseCase.execute(type: "maps", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsMap($0)},
                self.dictionarySearchCountUseCase.execute(type: "quests", keyword: self.initialState.keyword ?? "").map { Mutation.setCountsQuest($0)},
                
            ])
        // 검색 결과 화면에서 재검색 시
        case .searchButtonTapped(let keyword):
            let keyword = keyword ?? ""

            return Observable.concat([
                Observable.just(.setKeyword2(keyword)),
                self.dictionarySearchCountUseCase.execute(type: "search", keyword: keyword).map { Mutation.setCountsAll($0)},
                self.dictionarySearchCountUseCase.execute(type: "monsters", keyword: keyword).map { Mutation.setCountsMonster($0)},
                self.dictionarySearchCountUseCase.execute(type: "items", keyword: keyword).map { Mutation.setCountsItem($0)},
                self.dictionarySearchCountUseCase.execute(type: "npcs", keyword: keyword).map { Mutation.setCountsNpc($0)},
                self.dictionarySearchCountUseCase.execute(type: "maps", keyword: keyword).map { Mutation.setCountsMap($0)},
                self.dictionarySearchCountUseCase.execute(type: "quests", keyword: keyword).map { Mutation.setCountsQuest($0)},
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setKeyword(let keyword):
            newState.keyword = keyword
        case .setCountsAll(let items):
            newState.counts[0] = items.count ?? 0
            print("counts입니다111:\(newState.counts)")
        case .setCountsMonster(let items):
            newState.counts[1] = items.count ?? 0
            print("counts입니다22:\(newState.counts)")

        case .setCountsItem(let items):
            newState.counts[2] = items.count ?? 0
            print("counts입니다3333:\(newState.counts)")

        case .setCountsMap(let items):
            newState.counts[3] = items.count ?? 0
            print("counts입니다444:\(newState.counts)")

        case .setCountsNpc(let items):
            newState.counts[4] = items.count ?? 0
            print("counts입니다5555:\(newState.counts)")

        case .setCountsQuest(let items):
            newState.counts[5] = items.count ?? 0
            print("counts입니다666:\(newState.counts)")
        case .setKeyword2(let keyword):
            newState.keyword = keyword
         }
        
        return newState
    }
}
