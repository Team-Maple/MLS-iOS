import BaseFeature

public protocol MonsterFilterBottomSheetFactory {
    func make() -> BaseViewController & ModalPresentable
}
