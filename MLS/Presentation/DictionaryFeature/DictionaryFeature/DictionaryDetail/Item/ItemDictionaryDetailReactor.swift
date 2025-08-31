import DomainInterface

import ReactorKit

public final class ItemDictionaryDetailReactor: Reactor {
    
    public struct ItemInfo: Equatable {
        var name: String
        var desc: String
    }
    
    public struct MonsterInfo: Equatable {
        var name: String
        var level: String
    }
        
    public struct State {
        var type: DictionaryItemType
        // 아이템 임시 모델
        var itemInfos: [ItemInfo] = [
            ItemInfo(name: "물리공격력", desc: "22"),
            ItemInfo(name: "상점판매가", desc: "20000메소")
        ]
        // 몬스터 임시 모델
        var monsterInfos: [MonsterInfo] = [
            MonsterInfo(name: "여신 탑의 러스터픽시", level: "Lv. 99"),
            MonsterInfo(name: "스톤골렘", level: "Lv. 99"),
            MonsterInfo(name: "주니어 발록", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
            MonsterInfo(name: "불독", level: "Lv. 99"),
        ]
    }
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public var initialState: State
    private let disposeBag = DisposeBag()
    
    public init() {
        self.initialState = .init(type: .item)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
