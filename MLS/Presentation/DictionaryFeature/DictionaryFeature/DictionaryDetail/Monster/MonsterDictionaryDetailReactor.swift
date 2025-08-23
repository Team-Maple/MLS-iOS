import DomainInterface

import ReactorKit

public final class MonsterDictionaryDetailReactor: Reactor {
    /// UI 구현을 위한 임시 모델(몬스터 상세정보)
    struct TabMenu: Equatable {
        var infos: [Info]
        var maps: [Map]
        var Items: [Item]
        
        static func == (lhs: TabMenu, rhs: TabMenu) -> Bool {
            return lhs.infos == rhs.infos &&
            lhs.maps == rhs.maps &&
            lhs.Items == rhs.Items
        }
    }
    
    public struct Info: Equatable {
        var name: String
        var desc: String
    }
    // 임시 모델
    public struct Map: Equatable {
        var desc: String // 임시 라벨
    }
    public struct Item: Equatable {
        var desc: String // 임시 라벨
    }
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        var type: DictionaryItemType
        var name = "슈미의 의뢰"
        lazy var sectionTab: [DetailType] = self.type.detailTypes
        var subTextLabel = "LV.21"
        var tags = ["불약점", "불꽃약점", "불꽃 약점", "불 약점", "불약점", "불약점", "불꽃약점", "불꽃약점", "불꽃약점", "불꽃약점", "불꽃약점", "테스트테스트테스트", "테스트", "테스트", "테스트"]
        var menus = TabMenu(
            infos: [
                Info(name: "HP", desc: "400"),
                Info(name: "ATK", desc: "200"),
                Info(name: "DEF", desc: "100"),
                Info(name: "SPD", desc: "50"),
                Info(name: "EXP", desc: "400"),
                Info(name: "물리공격력", desc: "200"),
                Info(name: "필요명중률", desc: "400"),
                Info(name: "마법방어력", desc: "200"),
                Info(name: "1Lv 낮을 때마다", desc: "+0.93 명중 필요"),
                Info(name: "스티키 확인", desc: "확인"),
                Info(name: "스티키 확인", desc: "확인"),
                Info(name: "스티키 확인", desc: "확인"),
                Info(name: "스티키 확인", desc: "확인"),
                Info(name: "스티키 확인", desc: "확인"),
                Info(name: "스티키 확인", desc: "확인"),
                
            ], maps: [
                Map(desc: "임시 라벨")
            ], Items: [
                Item(desc: "임시 라벨")
            ])
    }
    
    public var initialState: State
    private let disposBag = DisposeBag()
    
    public init() {
        initialState = State(type: .monster)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}

