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
    }

    public enum Mutation {
        case navigateTo(Route)
        case setKeyword(String)
        case setCounts(DictionaryMainResponse)
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

    // MARK: - init
    public init(keyword: String?, dictionarySearchUseCase: FetchDictionarySearchListUseCase) {
        self.initialState = State(keyword: keyword)
        self.dictionarySearchUseCase = dictionarySearchUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backbuttonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .updateKeyword(let keyword):
            return Observable.just(.setKeyword(keyword))
        case .viewWillAppear:
            return self.dictionarySearchUseCase.execute(keyword: self.initialState.keyword ?? "").map {Mutation.setCounts($0)}
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setKeyword(let keyword):
            newState.keyword = keyword
        case .setCounts(let items):
            // response.items 를 type별로 그룹화해서 count 계산
            let grouped = Dictionary(grouping: items.contents, by: { $0.type })
            
            // 순서대로 count 배열을 채운다
            let allCount = items.totalElements
            let monsterCount = grouped[.monster]?.count ?? 0
            let itemCount = grouped[.item]?.count ?? 0
            let mapCount = grouped[.map]?.count ?? 0
            let npcCount = grouped[.npc]?.count ?? 0
            let questCount = grouped[.quest]?.count ?? 0
            
            // 배열 순서대로 넣기
            newState.counts = [
                allCount,
                monsterCount,
                itemCount,
                mapCount,
                npcCount,
                questCount
            ]
        }
        
        return newState
    }
}
