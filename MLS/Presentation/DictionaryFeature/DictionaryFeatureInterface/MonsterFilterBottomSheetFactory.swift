import BaseFeature

public protocol MonsterFilterBottomSheetFactory {
    func make(startLevel: Int, endLevel: Int, onFilterSelected: @escaping ((Int, Int) -> Void)) -> BaseViewController & ModalPresentable
}
