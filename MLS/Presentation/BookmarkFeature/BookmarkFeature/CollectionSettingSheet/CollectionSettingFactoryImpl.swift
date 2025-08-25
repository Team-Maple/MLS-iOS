import BaseFeature
import BookmarkFeatureInterface

public struct CollectionSettingFactoryImpl: CollectionSettingFactory {
    public init() {}

    public func make(setEditMenu: ((CollectionSettingMenu) -> Void)?) -> BaseViewController & ModalPresentable {
        let viewController = CollectionSettingViewController()
        viewController.reactor = CollectionSettingReactor()
        viewController.setMenu = setEditMenu
        return viewController
    }
}
