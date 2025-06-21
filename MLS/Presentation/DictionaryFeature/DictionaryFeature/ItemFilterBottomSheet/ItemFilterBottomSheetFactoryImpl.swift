import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {

    public init() {}

    public func make() -> BaseViewController {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetReactor()
        return viewController
    }
}
