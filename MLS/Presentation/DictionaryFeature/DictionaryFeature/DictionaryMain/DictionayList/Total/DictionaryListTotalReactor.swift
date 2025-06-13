import DesignSystem

import ReactorKit

public final class DictionaryListTotalReactor: Reactor, DictionaryListReactorType {
    public enum Action {
        case toggleBookmark(id: String)
    }

    public enum Mutation {
        case updateBookmark(id: String)
        case showBookmarkToast(id: String)
    }
    
    public struct State: DictionaryStateType {
        public var type = DictionaryType.total
        
        public var items = [
            DictionaryItem(id: "1",type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "2", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
            DictionaryItem(id: "3", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "4", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "5", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "6", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
            DictionaryItem(id: "7", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
            DictionaryItem(id: "8", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
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
        switch action {
        case let .toggleBookmark(id):
            if let item = currentState.items.first(where: { $0.id == id }), item.isBookmarked {
                return .just(.updateBookmark(id: id))
            } else {
                return .just(.showBookmarkToast(id: id))
            }
        }
    }
        
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateBookmark(id):
            newState.items = newState.items.map {
                guard $0.id == id else { return $0 }
                var updated = $0
                updated.isBookmarked.toggle()
                return updated
            }
            
        case .showBookmarkToast(let id):
            break
        }

        return newState
    }
}
