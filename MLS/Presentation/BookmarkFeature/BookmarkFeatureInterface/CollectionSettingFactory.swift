import BaseFeature

public protocol CollectionSettingFactory {
    func make(setEditMenu: ((CollectionSettingMenu) -> Void)?) -> BaseViewController & ModalPresentable
}
