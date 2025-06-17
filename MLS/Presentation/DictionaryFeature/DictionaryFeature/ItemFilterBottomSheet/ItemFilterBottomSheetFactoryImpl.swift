import BaseFeature
import DomainInterface
import DictionaryFeatureInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {

    public init() {}

    public func make() -> BaseViewController {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetViewReactor()
        return viewController
    }
}
