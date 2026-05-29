import MLSCore
import MLSDesignSystem

public protocol CollectionSettingFactory {
    func make(setEditMenu: ((CollectionSettingMenu) -> Void)?) -> BaseViewController & ModalPresentable
}
