import BaseFeature
import DictionaryFeatureInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetReactor()
        return viewController
    }
}
