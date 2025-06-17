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
        case filterSelected(indexPath: IndexPath)
        case filterDeselected(indexPath: IndexPath)
        case changeLevelRange(low: Int, high: Int)
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setScrolls(selectedIndex: Int?)
        case appendSelectedItem(indexPath: IndexPath)
        case removeSelectedItem(indexPath: IndexPath)
        case setLevelRange(low: Int, high: Int)
    }

    public struct State {
        var sections: [String] = ["직업/레벨", "무기", "발사체", "방어구", "장신구", "주문서", "기타"]
        var jobs: [String] = ["없음", "공용", "마법사", "전사", "궁수", "도적", "해적"]
        var weapons: [String] = ["한손검", "한손도끼", "한손둔기", "창", "단검", "두손검", "두손도끼", "두손둔기", "풀암", "활", "석궁", "완드", "스태프", "아대"]
        var projectiles: [String] = ["화살", "불릿", "표창"]
        var armors: [String] = ["모자", "전신", "상의", "하의", "장갑", "신발", "방패", "전신 갑옷" ]
        var accessories: [String] = ["귀고리", "망토", "훈장", "눈장식", "얼굴장식", "팬던트", "벨트", "반지", "어깨장식", "귀장식"]
        @Pulse var scrollCategories: [String] = ["무기 주문서", "방어구 주문서", "기타 주문서"]
        var originWeaponScrolls: [String] = ["한손검1", "한손검2", "한손검3", "한손검4", "한손검5", "한손검6", "한손검7", "한손검8", "한손검9", "한손검10"]
        var originArmorScrolls: [String] = ["갑옷1", "갑옷2", "갑옷3", "갑옷4", "갑옷5", "갑옷6", "갑옷7", "갑옷8", "갑옷9", "갑옷10"]
        var originEtcScrolls: [String] = ["기타1", "기타2", "기타3", "기타4", "기타5", "기타6", "기타7", "기타8", "기타9", "기타10"]
        @Pulse var weaponScrolls: [String] = []
        @Pulse var armorScrolls: [String] = []
        @Pulse var etcScrolls: [String] = []
        var etcItems: [String] = ["마스터리북", "스킬북", "소비", "설치", "이동수단"]

        var selectedItemIndexes: [IndexPath] = []
        var levelRange: (low: Int, high: Int) = (0, 200)
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
        case .filterSelected(let indexPath):
            let section = ItemFilterBottomSheetViewController.FilterSection(rawValue: indexPath.section)
            switch section {
            case .scrollCategories:
                return Observable.just(.setScrolls(selectedIndex: indexPath.row))
            default:
                return Observable.just(.appendSelectedItem(indexPath: indexPath))
            }
        case .filterDeselected(let indexPath):
            let section = ItemFilterBottomSheetViewController.FilterSection(rawValue: indexPath.section)
            switch section {
            case .scrollCategories:
                return Observable.just(.setScrolls(selectedIndex: nil))
            default:
                return Observable.just(.removeSelectedItem(indexPath: indexPath))
            }
        case .changeLevelRange(low: let low, high: let high):
            return Observable.just(.setLevelRange(low: low, high: high))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .appendSelectedItem(let indexPath):
            newState.selectedItemIndexes.insert(indexPath, at: 0)
            let selectedWeaponScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .weaponScrolls }.count
            let selectedArmorScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .armorsScrolls }.count
            let selectedEtcScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .etcScrolls }.count
            newState.scrollCategories = [
                "무기 주문서\(selectedWeaponScrollCount == 0 ? "" : " \(selectedWeaponScrollCount)")",
                "방어구 주문서\(selectedArmorScrollCount == 0 ? "" : " \(selectedArmorScrollCount)")",
                "기타 주문서\(selectedEtcScrollCount == 0 ? "" : " \(selectedEtcScrollCount)")"
            ]
        case .removeSelectedItem(let indexPath):
            if let removeIndex = newState.selectedItemIndexes.firstIndex(of: indexPath) {
                newState.selectedItemIndexes.remove(at: removeIndex)
            }
            let selectedWeaponScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .weaponScrolls }.count
            let selectedArmorScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .armorsScrolls }.count
            let selectedEtcScrollCount = newState.selectedItemIndexes.filter { ItemFilterBottomSheetViewController.FilterSection(rawValue: $0.section) == .etcScrolls }.count
            newState.scrollCategories = [
                "무기 주문서\(selectedWeaponScrollCount == 0 ? "" : " \(selectedWeaponScrollCount)")",
                "방어구 주문서\(selectedArmorScrollCount == 0 ? "" : " \(selectedArmorScrollCount)")",
                "기타 주문서\(selectedEtcScrollCount == 0 ? "" : " \(selectedEtcScrollCount)")"
            ]
        case .setScrolls(let selectedIndex):
            switch selectedIndex {
            case 0:
                newState.weaponScrolls = newState.originWeaponScrolls
                newState.armorScrolls = []
                newState.etcScrolls = []
            case 1:
                newState.weaponScrolls = []
                newState.armorScrolls = newState.originArmorScrolls
                newState.etcScrolls = []

            case 2:
                newState.weaponScrolls = []
                newState.armorScrolls = []
                newState.etcScrolls = newState.originEtcScrolls
            default:
                newState.weaponScrolls = []
                newState.armorScrolls = []
                newState.etcScrolls = []
            }
        case .setLevelRange(low: let low, high: let high):
            let levelSection: IndexPath = .init(row: 0, section: ItemFilterBottomSheetViewController.FilterSection.level.rawValue)
            if low == 0 && high == 200 {
                if let removeIndex = newState.selectedItemIndexes.firstIndex(of: levelSection) { newState.selectedItemIndexes.remove(at: removeIndex) }
            } else {
                if !newState.selectedItemIndexes.contains(levelSection) { newState.selectedItemIndexes.insert(levelSection, at: 0) }
            }
            newState.levelRange = (low, high)
        }
        return newState
    }
}
