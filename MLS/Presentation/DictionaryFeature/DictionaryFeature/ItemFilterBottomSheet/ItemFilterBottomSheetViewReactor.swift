import Foundation

import ReactorKit
import RxCocoa
import RxSwift

final public class ItemFilterBottomSheetViewReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }
    // MARK: - Reactor
    public enum Action {
        case closeButtonTapped
        case filterTapped(indexPaths: [IndexPath]?)
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setState
    }

    public struct State {
        var sections: [String] = [
            "직업/레벨",
            "무기",
            "발사체",
            "방어구",
            "장신구",
            "주문서",
            "기타"
        ]
        var jobs: [String] = [
            "없음",
            "공용",
            "마법사",
            "전사",
            "궁수",
            "도적",
            "해적"
        ]
        var weapons: [String] = [
            "한손검",
            "한손도끼",
            "한손둔기",
            "창",
            "단검",
            "두손검",
            "두손도끼",
            "두손둔기",
            "풀암",
            "활",
            "석궁",
            "완드",
            "스태프",
            "아대"
        ]
        var projectiles: [String] = [
            "화살",
            "불릿",
            "표창"
        ]
        var armors: [String] = [
            "모자",
            "전신",
            "상의",
            "하의",
            "장갑",
            "신발",
            "방패",
            "전신 갑옷"
        ]
        var accessories: [String] = [
            "귀고리",
            "망토",
            "훈장",
            "눈장식",
            "얼굴장식",
            "팬던트",
            "벨트",
            "반지",
            "어깨장식",
            "귀장식"
        ]
        var scrollTypes: [String] = [
            "무기 주문서",
            "방어구 주문서",
            "기타 주문서"
        ]
        var scrolls: [String] = [
//            "한손검",
//            "한손검",
//            "한손검"
        ]
        var etcItems: [String] = [
            "마스터리북",
            "스킬북",
            "소비",
            "설치",
            "이동수단"
        ]

        @Pulse var route: Route = .none
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
        case .closeButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .filterTapped(let indexPaths):
            print(indexPaths)
            return Observable.just(.setState)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setState:
            return newState
        }

        return newState
    }
}
