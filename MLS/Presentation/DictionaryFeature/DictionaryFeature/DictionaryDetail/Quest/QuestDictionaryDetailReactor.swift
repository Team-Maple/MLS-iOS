import DomainInterface

import ReactorKit

final class QuestDictionaryDetailReactor: Reactor {
    public struct DetailInfo: Equatable {
        var name: String
        var desc: String
    }
    public struct CompleteConditionInfo: Equatable {
        var name: String
        var desc: String
        var clickable: Bool
    }
    
    public struct RewardInfo: Equatable {
        var name: String
        var desc: String
    }
    
    public struct State {
        var type: DictionaryItemType
        // 퀘스트 완료조건 임시모델
        var questConditionInfo: [CompleteConditionInfo] = [CompleteConditionInfo(name: "스텀프", desc: "11", clickable: true), CompleteConditionInfo(name: "초록버섯", desc: "5", clickable: false)]
        
        // 퀘스트 상세정보 임시모델
        var questDetailInfo: [DetailInfo] = [DetailInfo(name: "시작 최소 레벨", desc: "1"), DetailInfo(name: "시작 최대 레벨", desc: "5")]
        
        // 퀘스트 보상 임시모델
        var questRewardInfo: [RewardInfo] = [RewardInfo(name: "메소", desc: "500"), RewardInfo(name: "파란 포션", desc: "100")]
    }
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public var initialState: State
    private let disposeBag = DisposeBag()
    
    public init() {
        self.initialState = .init(type: .quest)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {

    }

    public func reduce(state: State, mutation: Mutation) -> State {

    }
}
