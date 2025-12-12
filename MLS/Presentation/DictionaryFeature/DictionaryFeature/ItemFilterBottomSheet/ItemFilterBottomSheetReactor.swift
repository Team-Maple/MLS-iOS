import Foundation

import ReactorKit
import RxSwift

public final class ItemFilterBottomSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithSelection([(String, String)])
        case resetFilters
    }

    // MARK: - Reactor
    public enum Action {
        case closeButtonTapped
        case filterSelected(indexPath: IndexPath)
        case filterDeselected(indexPath: IndexPath)
        case changeLevelRange(low: Int, high: Int)
        case applyButtonTapped([(String, String)])
        case resetFilters
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setScrolls(selectedIndex: Int?)
        case appendSelectedItem(indexPath: IndexPath)
        case removeSelectedItem(indexPath: IndexPath)
        case setLevelRange(low: Int, high: Int)
        case resetFilters
    }

    public struct State {
        var sections: [String] = ["직업/레벨", "무기", "발사체", "방어구", "장신구", "주문서", "기타"]
        var jobs: [String] = ["없음", "공용", "마법사", "전사", "궁수", "도적"]
        var weapons: [String] = ["한손검", "한손도끼", "한손둔기", "창", "단검", "두손검", "두손도끼", "두손둔기", "폴암", "활", "석궁", "완드", "스태프", "아대"]
        var projectiles: [String] = ["화살", "표창"] // 불렛은 제거
        var armors: [String] = ["모자", "상의", "하의", "장갑", "신발", "방패", "전신갑옷"] // 전신 = 전신갑옷?
        var accessories: [String] = ["귀고리", "망토", "훈장", "눈장식", "얼굴장식", "팬던트", "벨트", "반지", "어깨장식"] // 귀장식 데이터 안줌 -> 귀장식 = 귀고리, 훈장은 서버에서 데이터 안줌.
        @Pulse var scrollCategories: [String] = ["무기 주문서", "방어구 주문서", "기타 주문서"]
        var originWeaponScrolls: [String] = ["한손검", "한손도끼", "한손둔기", "단검", "완드", "스태프", "두손검", "두손도끼", "두손둔기", "창", "폴암", "활", "석궁", "아대"]
        var originArmorScrolls: [String] = ["투구", "상의", "하의", "전신갑옷", "신발", "장갑", "망토", "방패", "귀장식"]
        var originEtcScrolls: [String] = ["펫장비", "연성서", "귀환주문서"]
        @Pulse var weaponScrolls: [String] = []
        @Pulse var armorScrolls: [String] = []
        @Pulse var etcScrolls: [String] = []
        var etcItems: [String] = ["마스터리북", "스킬북", "소비", "설치", "이동수단"]
        var selectedScrollIndexes: Int?
        var selectedItemIndexes: [IndexPath] = []
        var levelRange: (low: Int, high: Int) = (1, 200)
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
            // 닫기버튼 누르면 선택했던 필터 초기화 해줘야함
            return .concat([Observable.just(.navigateTo(route: .dismiss)), Observable.just(.resetFilters)])
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
        case .applyButtonTapped(let selectedItems):
            return .just(.navigateTo(route: .dismissWithSelection(selectedItems)))
        case .resetFilters:
            return Observable.just(.resetFilters)
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
            newState.selectedScrollIndexes = selectedIndex
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
        case .resetFilters:
            newState.selectedItemIndexes = []
            newState.levelRange = (0, 200)
            newState.scrollCategories = ["무기 주문서", "방어구 주문서", "기타 주문서"]
            newState.weaponScrolls = []
            newState.armorScrolls = []
            newState.etcScrolls = []
            newState.selectedScrollIndexes = nil
        }
        return newState
    }
}
