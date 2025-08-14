import DomainInterface

import ReactorKit

public final class DictionaryDetailReactor: Reactor {
    /// UI 구현을 위한 임시 모델 (상세 정보)
    /// 추후 탭 마다 API 호출로 변경 - 식별자만 필요
    struct TabMenu: Equatable {
        var infos: [Info]
        var maps: [Map]
        
        static func == (lhs: TabMenu, rhs: TabMenu) -> Bool {
            return lhs.infos == rhs.infos &&
                lhs.maps == rhs.maps
        }
    }
    // 몬스터 정보 임시 모델
    struct DropMonster: Equatable {
        var name: String
        var monsterLevel: String
    }
    
    public enum Route {
        case none
        case dismiss
        case dictionary
        case report
        case selectItem(Info)
    }

    /// UI 구현을 위한 임시 모델 (상세 정보)
    public struct Info: Equatable {
        var name: String
        var desc: String
    }

    /// UI 구현을 위한 임시 모델 (출현 맵)
    public struct Map: Equatable {}

    public enum Action {
        case backButtonTapped
        case dictionaryButtonTapped
        case reportButtonTapped
        case tabSelected(Int)
        case selectItem(Info)
    }

    public enum Mutation {
        case navigateTo(Route)
        // 탭 선택 이벤트 처리
        case setSelectedIndex(Int)
    }

    public struct State {
        @Pulse var route: Route
        var selectedTabIndex: Int = 0
        // UI 구현을 위한 임시 속성들이므로 각 DictionaryItem과 비슷한 형태의 속성으로 바뀔예정
        var type: DictionaryItemType
        lazy var sectionTab: [DetailType] = self.type.detailTypes
        var name = "슈미의 의뢰"
        var tags = ["불약점", "불꽃약점", "불꽃 약점", "불 약점", "불약점", "불약점", "불꽃약점", "불꽃약점", "불꽃약점", "불꽃약점", "불꽃약점"]
        var menus = TabMenu(
            infos: [
                Info(name: "Hp", desc: "400"),
                Info(name: "Mp", desc: "0"),
                Info(name: "물리공격력", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
                Info(name: "필요명중률", desc: "30"),
            ],
            maps: [
                Map(),
                Map(),
            ]
        )
        
        var dropMonster = [DropMonster(name: "여신탑의 러스터 픽시", monsterLevel: "25"), DropMonster(name: "여신탑의 러스터 픽시", monsterLevel: "25"), DropMonster(name: "여신탑의 러스터 픽시", monsterLevel: "25"), DropMonster(name: "여신탑의 러스터 픽시", monsterLevel: "25"), DropMonster(name: "여신탑의 러스터 픽시", monsterLevel: "25")]
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    public init() {
        initialState = State(route: .none, type: .item)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tabSelected(let index):
            return .just(.setSelectedIndex(index))
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .dictionaryButtonTapped:
            return .just(.navigateTo(.dictionary))
        case .reportButtonTapped:
            return .just(.navigateTo(.report))
        case .selectItem(let item):
            return .just(.navigateTo(.selectItem(item)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedIndex(let index):
            newState.selectedTabIndex = index
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
