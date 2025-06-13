import DesignSystem
import ReactorKit

public final class DictionaryListQuestReactor: Reactor, DictionaryListReactorType {
    public enum Action {}
    public enum Mutation {}
    public struct State: DictionaryStateType {
        public var type = DictionaryType.monster
        
        public var items = [
            DictionaryItem(id: "11", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "12", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
            DictionaryItem(id: "13", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "14", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "15", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "16", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
            DictionaryItem(id: "17", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "18", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
        ]
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
        
    // MARK: - init
    public init() {
        self.initialState = State()
    }
        
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {}
    }
        
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {}
            
        return newState
    }
}
